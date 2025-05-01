// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Appbar extends StatelessWidget {
  final Widget iconz;
  final String drawertitle;
  final String drawersubtitle;
  final Widget icons;

  const Appbar({
    super.key,
    required this.iconz,
    required this.drawertitle,
    required this.drawersubtitle,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: iconz,
      title: Text(drawertitle),
      subtitle: Text(drawersubtitle),
      trailing: icons,
    );
  }
}
