import 'dart:async';
import 'package:blog_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/supabase_secrets/app_sectrets.dart';
import 'package:blog_app/core/usecase/current_user.dart';
import 'package:blog_app/core/usecase/user_login.dart';
import 'package:blog_app/core/usecase/user_signup.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecase/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSectrets.supabaseUrl,
    anonKey: AppSectrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // COre Dependencies
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //Data Source
  serviceLocator
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    //Repository
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    //USersignup Usecase
    ..registerLazySingleton(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    //usersignin Usecase
    ..registerLazySingleton(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    //CurrentUser Usecase
    ..registerLazySingleton(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    //AuthBloc
    ..registerFactory(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator

    //Data Source
    ..registerLazySingleton<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    //Repository
    ..registerLazySingleton<BlogRepository>(
      () => BlogRepositoryimpl(
        serviceLocator(),
      ),
    )
    //Upload Usecase
    ..registerLazySingleton(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    //Get All Blogs Usecase
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
