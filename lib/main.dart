import 'dart:developer';
import 'package:blog_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/dependecies/init_dependencies.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<BlogBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final navigationKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.read<AppUserCubit>().updateUser(state.profile);
            }
          },
        ),
        BlocListener<AppUserCubit, AppUserState>(
          listener: (context, state) {
            if (state is AppUserLoggedIn) {
              navigationKey.currentContext?.go('/blog');
            } else {
              navigationKey.currentContext?.go('/login');
            }
          },
          child: Container(),
        )
      ],
      child: MaterialApp.router(
        routerConfig: router(navigationKey),
        title: 'BlogApp',
        theme: AppTheme.darkThemeMode,
        debugShowCheckedModeBanner: false,
      ),
      /*child: MaterialApp(
        title: 'Blog App',
        theme: AppTheme.darkThemeMode,
        home: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              return BlogPage();
            }
            return const LoginPage();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),*/
    );
  }
}

// Go Routing

GoRouter router(
  GlobalKey<NavigatorState> navigationKey,
) =>
    GoRouter(
      navigatorKey: navigationKey,
      initialLocation: "/",
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: "/",
          name: 'Splash',
          builder: (context, state) => Scaffold(),
        ),
        GoRoute(
          path: "/login",
          name: 'Login Page',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: "/blog",
          name: 'Home',
          builder: (context, state) => BlogPage(),
        ),
        GoRoute(
          path: "/add_blogpage",
          name: 'Add_blogpage',
          builder: (context, state) => AddNewBlogPage(),
        ),
      ],
    );

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
