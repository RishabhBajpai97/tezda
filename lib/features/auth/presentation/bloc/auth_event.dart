part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignup extends AuthEvent {
  final String email;
  final String name;
  final String password;

  AuthSignup({required this.email, required this.name, required this.password});
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

final class AuthIsLoggedIn extends AuthEvent {}

final class AuthLogout extends AuthEvent {}
