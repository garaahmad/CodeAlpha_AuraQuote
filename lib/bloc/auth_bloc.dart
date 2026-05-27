import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    FirebaseFirestore? firestore,
  })  : _authRepository = authRepository,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(AuthInitial()) {
    on<CheckAuthStatusRequested>(_onCheckAuthStatus);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<SignInWithAppleRequested>(_onSignInWithApple);
    on<SignOutRequested>(_onSignOut);
    on<SignUpRequested>(_onSignUp);
    on<SignInRequested>(_onSignIn);

    _userSubscription = _authRepository.currentUser.listen((_) {
      add(CheckAuthStatusRequested());
    });
  }

  void _onCheckAuthStatus(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) {
    final user = _authRepository.currentUserSync;
    if (user != null) {
      emit(AuthSuccess(user: user));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithGoogle();
    } on AuthException catch (e) {
      emit(AuthFailure(error: e.message));
    } catch (e) {
      emit(AuthFailure(error: 'Google sign-in failed. Please try again.'));
    }
  }

  Future<void> _onSignInWithApple(
    SignInWithAppleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithApple();
    } on AuthException catch (e) {
      emit(AuthFailure(error: e.message));
    } catch (e) {
      emit(AuthFailure(error: 'Apple sign-in failed. Please try again.'));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(AuthFailure(error: 'Sign out failed. Please try again.'));
    }
  }

  Future<void> _onSignUp(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await credential.user?.updateDisplayName(event.name);
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': event.name,
        'email': event.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(error: _mapAuthError(e.code)));
    } catch (e) {
      emit(AuthFailure(error: 'An unexpected error occurred.'));
    }
  }

  Future<void> _onSignIn(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(error: _mapAuthError(e.code)));
    } catch (e) {
      emit(AuthFailure(error: 'An unexpected error occurred.'));
    }
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
