part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class LogInEvent extends AuthEvent {
  String username;
  String password;
  LogInEvent({required this.username, required this.password});
}

final class RegisterEvent extends AuthEvent {
  String username;
  String email;
  String password;
  RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
  });
}
