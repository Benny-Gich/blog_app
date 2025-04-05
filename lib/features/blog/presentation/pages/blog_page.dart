import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_delete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => BlogPage(),
      );
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlogBloc>.value(
      value: context.read()..add(BlogFetchAllBlogs()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blog App'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  AddNewBlogPage.route(),
                );
              },
              icon: Icon(
                CupertinoIcons.add_circled,
              ),
            ),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            // if (state is BlogFailure) {
            //   showSnackBar(context, state.error);
            // }
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
            // if (state is BlogDisplaySuccess) {
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
                // return Dismissible(
                //   key: Key(blog.id),
                //   direction: DismissDirection.horizontal,
                //   background: Container(
                //     color: AppPallete.greyColor,
                //     alignment: Alignment.centerLeft,
                //     padding: EdgeInsets.only(right: 20),
                //     child: Icon(
                //       Icons.delete_forever,
                //     ),
                //   ),
                //   secondaryBackground: Container(
                //     color: AppPallete.errorColor,
                //     alignment: Alignment.centerRight,
                //     padding: EdgeInsets.only(right: 20),
                //     child: Icon(
                //       Icons.share_outlined,
                //     ),
                //   ),
                //   confirmDismiss: (direction) async {
                //     if (direction == DismissDirection.startToEnd) {
                //       return await showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return AlertDialog(
                //             title: Text('Confirm Delete'),
                //             content: Text('Are you sure?'),
                //             actions: [
                //               TextButton(
                //                 onPressed: () =>
                //                     Navigator.of(context).pop(false),
                //                 child: Text('CANCEL'),
                //               ),
                //               TextButton(
                //                 onPressed: () {},
                //                 child: Text('DELETE'),
                //               ),
                //             ],
                //           );
                //         },
                //       );
                //     } else {
                //       showSnackBar(
                //           context, 'Sharing: ${BlogViewerPage(blog: blog)}');
                //     }
                //   },
                //   onDismissed: (direction) {
                //     if (direction == DismissDirection.startToEnd) {
                //       showSnackBar(context, 'Post deleted');
                //     }
                //   },
                //   child: BlogCard(
                //     blog: blog,
                //     color: index % 3 == 0
                //         ? AppPallete.gradient1
                //         : index % 3 == 1
                //             ? AppPallete.gradient2
                //             : AppPallete.gradient3,
                //   ),
                // );
              },
            );
            // }
            // return SizedBox();
          },
        ),
      ),
    );
  }
}
