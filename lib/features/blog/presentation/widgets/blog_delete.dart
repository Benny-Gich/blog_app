import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogDelete extends StatelessWidget {
  const BlogDelete({
    super.key,
    required this.blog,
    required this.onDelete,
    required this.onShare,
    required this.child,
  });
  final Blog blog;
  final void Function(Blog blog) onDelete;
  final void Function(Blog blog) onShare;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(blog.id),
      direction: DismissDirection.horizontal,
      background: Container(
        color: AppPallete.greyColor,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete_forever,
        ),
      ),
      secondaryBackground: Container(
        color: AppPallete.errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.share_outlined,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Delete'),
                content: Text('Are you sure?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('DELETE'),
                  ),
                ],
              );
            },
          );
        }
        if (direction == DismissDirection.endToStart) {
          // showSnackBar(context, 'Sharing: ${BlogViewerPage(blog: blog)}');
          return true;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onDelete.call(blog);
        }
        if (direction == DismissDirection.endToStart) {
          onShare.call(blog);
        }
      },
      child: child,
    );
  }
}
