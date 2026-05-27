import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppRoutingEvent {}

class AppStarted extends AppRoutingEvent {}

class OnboardingFinished extends AppRoutingEvent {}

abstract class AppRoutingState {}

class AppRoutingSplash extends AppRoutingState {}

class AppRoutingOnboarding extends AppRoutingState {}

class AppRoutingAuthFlow extends AppRoutingState {}

class AppRoutingBloc extends Bloc<AppRoutingEvent, AppRoutingState> {
  AppRoutingBloc() : super(AppRoutingSplash()) {
    on<AppStarted>(_onAppStarted);
    on<OnboardingFinished>(_onOnboardingFinished);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AppRoutingState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 2500));
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTimeUser') ?? true;
    emit(isFirstTime ? AppRoutingOnboarding() : AppRoutingAuthFlow());
  }

  void _onOnboardingFinished(
    OnboardingFinished event,
    Emitter<AppRoutingState> emit,
  ) {
    emit(AppRoutingAuthFlow());
  }
}
