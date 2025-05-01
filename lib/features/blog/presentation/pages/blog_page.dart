// ignore_for_file: use_build_context_synchronously
import 'package:blog_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/appbar.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => BlogPage(),
      );
  //final signOut _signOut = signOut();

  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlogBloc>.value(
      value: context.read()..add(BlogFetchAllBlogs()),
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            spacing: 10,
            children: [
              DrawerHeader(
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('icons/blog.png'),
                ),
              ),
              Appbar(
                iconz: Icon(Icons.logout),
                drawertitle: 'Sign Out',
                drawersubtitle: 'Logout of your account',
                icons: IconButton(
                  onPressed: () async {
                    final logout = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Logout'),
                          content: Text('Do you want to Logout?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context, true);
                              },
                              child: Text('LOGOUT'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text('CANCEL'),
                            ),
                          ],
                        );
                      },
                    );
                    if (logout == true && context.mounted) {
                      context.read<AppUserCubit>().signOut();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Blog App'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                context.go('/add_blogpage');
              },
              icon: Icon(
                CupertinoIcons.add_circled,
              ),
            ),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            switch (state.status) {
              case BlogStatus.failure:
                showSnackBar(context, state.error);
                break;
              default:
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case BlogStatus.loading:
                return Loader();
              default:
            }
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? AppPallete.gradient1
                      : index % 3 == 1
                          ? AppPallete.gradient2
                          : AppPallete.gradient3,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
