import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_delete.dart';
//import 'package:blog_app/features/blog/presentation/widgets/blog_delete.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BlogDelete(
      blog: blog,
      onDelete: (blog) {
        //call delete
        showSnackBar(context, 'Post ${blog.posterName} deleted');
      },
      onShare: (blog) {
        //call share
        showSnackBar(context, 'Post ${blog.posterName} shared');
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            BlogViewerPage.route(blog),
          );
        },
        child: Container(
          height: 200,
          margin: EdgeInsets.all(10).copyWith(bottom: 4),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: blog.topics
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Chip(
                                    label: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    blog.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 40,
                    child: Text(
                      blog.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppPallete.backgroundColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('${calculateReadingTime(blog.content)} min'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
