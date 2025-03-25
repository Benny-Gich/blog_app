part of 'app_user_cubit.dart';

sealed class AppUserState extends Equatable {
  const AppUserState();

  @override
  List<Object> get props => [];
}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final Profile profile;
  const AppUserLoggedIn(this.profile);
}
  //core cannot depend on other features
  // other features can depend on core