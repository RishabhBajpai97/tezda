part of 'auth_bloc.dart';

@immutable
sealed class AuthBlocState {}

final class AuthInitial extends AuthBlocState {}

final class AuthLoading extends AuthBlocState {}

final class AuthSuccess extends AuthBlocState {
  final User user;

  AuthSuccess({required this.user});
}

final class AuthFailure extends AuthBlocState {
  final String message;

  AuthFailure({required this.message});
}
