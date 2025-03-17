import 'dart:async';
import 'package:blog_app/core/supabase_secrets/app_sectrets.dart';
import 'package:blog_app/core/usecase/user_login.dart';
import 'package:blog_app/core/usecase/user_signup.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSectrets.supabaseUrl,
    anonKey: AppSectrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
    ),
  );
}
