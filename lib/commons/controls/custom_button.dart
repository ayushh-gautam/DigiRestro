// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../utils/dimension.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? radius;
  final double? width;
  final double? height;
  final Color? color;
  final Color? overlayColor;
  final String? text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? widget;
  final BorderSide? borderSide;
  final double? elevation;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    this.onTap,
    this.radius,
    this.width,
    this.height,
    this.color,
    this.text,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.widget,
    this.borderSide,
    this.elevation,
    this.padding,
    this.overlayColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
            overlayColor: MaterialStatePropertyAll(overlayColor),
            minimumSize:
                MaterialStatePropertyAll(Size(width ?? 350, height ?? 55)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: borderSide ?? BorderSide.none,
                borderRadius: BorderRadius.circular(radius ?? 100),
              ),
            ),

            ///  [If_needed] //

            fixedSize: MaterialStateProperty.all(
              Size(width ?? 350, height ?? 55),
            ),
            backgroundColor: MaterialStateProperty.all(
              color ?? AppColor.newPrimary,
            ),
            elevation: MaterialStatePropertyAll(elevation),
            padding: MaterialStatePropertyAll(padding)),
        child: text != null
            ? Text(
                text!,
                style: TextStyle(
                  fontSize: fontSize ?? 20,
                  color: textColor ?? AppColor.black,
                  fontWeight: fontWeight ?? FontWeightManager.bold,
                ),
              )
            : widget);
  }
}

// Replace AppColor and FontWeightManager with your actual definitions
