import 'package:blog_app/core/common/entities/profile.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit(this.authRepository) : super(AppUserInitial());
  void updateUser(Profile? profile) {
    if (profile == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(profile));
    }
  }

  final AuthRepository authRepository;
  Future<void> signOut() async {
    await authRepository.signOut();
    emit(AppUserInitial());
  }
}
