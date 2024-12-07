import 'package:flutter/material.dart';

extension ExtendedWidget on Widget {
  Widget addPadding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget addMargin(EdgeInsets padding) {
    return Container(
      margin: padding,
      child: this,
    );
  }
}
