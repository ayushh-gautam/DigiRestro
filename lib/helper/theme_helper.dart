import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_color.dart';
import '../utils/string_constant.dart';

class AppTheme {
  static String darkTheme = APP_THEME_DARK;
  static String lightTheme = APP_THEME_LIGHT;
}

class ThemeHelper {
  // ignore: non_constant_identifier_names
  static String CURRENT_THEME = "";
  Color defaultLightTextColor = const Color(0xFF222222);
  Color defaultDarkTextColor = const Color(0xFFF7F7F7);
  static ThemeData? _currentAppThemeData;

  ThemeData? getAppTheme(BuildContext context) {
    return _currentAppThemeData;
  }

  getStatusBar(context, {color}) {
    return const SystemUiOverlayStyle().copyWith(
      statusBarColor: color ??
          Theme.of(context).appBarTheme.backgroundColor, //top bar color
      statusBarIconBrightness: Theme.of(context)
          .appBarTheme
          .systemOverlayStyle
          ?.statusBarBrightness, //top bar icons
      systemNavigationBarColor: color ??
          Theme.of(context).appBarTheme.backgroundColor, //bottom bar color
      systemNavigationBarIconBrightness: Theme.of(context)
                  .appBarTheme
                  .systemOverlayStyle
                  ?.statusBarBrightness ==
              Brightness.light
          ? Brightness.dark
          : Brightness.light,
    );
  }

  static var mySystemTheme = SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.white, //top bar color
    statusBarIconBrightness: Brightness.dark, //top bar icons
    systemNavigationBarColor: Colors.white, //bottom bar color
    systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
  );

  ThemeData generateAppTheme(
    BuildContext context,
    AppThemeState selectedTheme,
  ) {
    CURRENT_THEME = selectedTheme.name;
    if (selectedTheme.name == APP_THEME_LIGHT) {
      _currentAppThemeData = ThemeData(
          primaryColor: Colors.black,
          primaryColorDark: Colors.white38,
          scaffoldBackgroundColor: AppColor.white,
          appBarTheme: AppBarTheme(
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColor
                  .white)); // define all theme color here -> (light theme)
    } else {
      _currentAppThemeData = ThemeData(
        primaryColor: Colors.white,
        primaryColorDark: Colors.black87,
        scaffoldBackgroundColor: AppColor.black,
      );
    }

    return _currentAppThemeData!;
  }
}
