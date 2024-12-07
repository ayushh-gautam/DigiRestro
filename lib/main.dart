import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:DigiRestro/firebase_options.dart';
import 'package:DigiRestro/service_locator.dart';
import 'package:DigiRestro/src/view/auth/login.dart';

import 'helper/theme_helper.dart';
import 'multi_bloc_provider.dart';
import 'utils/string_constant.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocators();
  runApp(const MultiBlocProviderClass(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 755),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'DigiRestro',
          builder: EasyLoading.init(),
          theme: ThemeHelper()
              .generateAppTheme(context, AppThemeState.app_theme_light),
          debugShowCheckedModeBanner: false,
          home: const LoginPage(),
        );
      },
    );
  }
}
