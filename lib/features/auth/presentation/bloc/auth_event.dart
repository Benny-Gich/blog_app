part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String name;
  final String password;

  AuthSignUp({
    required this.email,
    required this.name,
    required this.password,
  });
  @override
  List<Object?> get props => [email, name, password];
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [email, password];
}
