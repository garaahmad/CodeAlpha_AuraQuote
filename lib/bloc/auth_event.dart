abstract class AuthEvent {}

class SignInWithGoogleRequested extends AuthEvent {}

class SignInWithAppleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({
    required this.email,
    required this.password,
  });
}
