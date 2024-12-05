// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../utils/dimension.dart';

class CustomTextField extends StatefulWidget {
  final bool? obscureText;
  final TextEditingController controller;
  final String Function(String?)? validator;
  final Widget? prefix;
  final String? hintText;
  final BorderSide? borderSide;
  final FocusNode? focusNode;

  const CustomTextField({
    this.obscureText,
    required this.controller,
    this.validator,
    this.prefix,
    this.hintText,
    this.borderSide,
    this.focusNode,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText ?? false,
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: widget.prefix,
        contentPadding: const EdgeInsets.all(AppPadding.p10),
        hintText: widget.hintText,
        helperStyle: TextStyle(
          fontSize: 20,
          color: AppColor.scaffoldColor,
        ),
        border: OutlineInputBorder(
          borderSide: widget.borderSide ?? BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

// Add your AppPadding, FontSize, AppColor, and AppSize definitions here
