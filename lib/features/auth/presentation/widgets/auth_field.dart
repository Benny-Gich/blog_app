// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  String hinttext;
  final TextEditingController controller;
  final bool isObscureText;

  AuthField({
    super.key,
    required this.hinttext,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      decoration: InputDecoration(
        hintText: hinttext,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please input $hinttext!";
        }
        return null;
      },
    );
  }
}
