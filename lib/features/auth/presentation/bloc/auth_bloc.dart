import 'package:blog_app/core/usecase/user_login.dart';
import 'package:blog_app/core/usecase/user_signup.dart';
import 'package:blog_app/features/auth/domain/entities/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthLogin>(_onAuthLogin);
    on<AuthSignUp>(_onAuthSignup);
  }
  void _onAuthSignup(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParms(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    res.fold(
      (failure) => emit(
        AuthFailure(failure.message),
      ),
      (profile) => emit(
        AuthSuccess(profile),
      ),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(UserLoginParams(
      email: event.email,
      password: event.password,
    ));
    res.fold(
      (failure) => emit(
        AuthFailure(failure.message),
      ),
      (profile) => emit(
        AuthSuccess(profile),
      ),
    );
  }
}
