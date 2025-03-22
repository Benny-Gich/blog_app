part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final Profile profile;
  AuthSuccess(this.profile);
  @override
  List<Object?> get props => [profile];
}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}
