// ignore: file_names
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/string_constant.dart';

class CustomText extends StatelessWidget {
  CustomText({
    Key? key,
    required this.text,
    this.fontName,
    this.color,
    this.size,
    this.letterSpacing,
    this.maxLines,
    this.onTap,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
  }) : super(key: key);
  //initializing variables
  final String text;
  final String? fontName;
  final Color? color;
  final double? size;
  final double? letterSpacing;
  final int? maxLines;
  final void Function()? onTap;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        
        text,
        maxLines: maxLines ?? 7,
        style: fontName == AppFonts.poppins
            ? GoogleFonts.poppins(
                color: color ?? Theme.of(context).primaryColor,
                fontSize: size ?? 18,
                fontStyle: fontStyle,
                decoration: textDecoration,
                decorationColor: Colors.blue,
                fontWeight: fontWeight)
            : fontName == AppFonts.inter
                ? GoogleFonts.inter(
                    color: color ?? Theme.of(context).primaryColor,
                    fontSize: size ?? 18,
                    fontStyle: fontStyle,
                    decoration: textDecoration,
                    decorationColor: Colors.blue,
                    fontWeight: fontWeight)
                : fontName == AppFonts.roboto
                    ? GoogleFonts.roboto(
                        color: color ?? Theme.of(context).primaryColor,
                        fontSize: size ?? 18,
                        fontStyle: fontStyle,
                        decoration: textDecoration,
                        decorationColor: Colors.blue,
                        fontWeight: fontWeight)
                    : TextStyle(
                      
                        letterSpacing: letterSpacing ?? 0,
                        color: color ?? Theme.of(context).primaryColor,
                        fontSize: size ?? 18,
                        fontStyle: fontStyle,
                        decoration: textDecoration,
                        decorationColor: Colors.blue,
                        fontWeight: fontWeight),
      ),
    );
  }
}
