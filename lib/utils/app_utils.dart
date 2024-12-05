import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../commons/controls/custom_image_network.dart';
import 'asset_manager.dart';
import 'dimension.dart';

class AppUtils {
  static void showLoadingDialog(context,
      {customMessage = "Please wait...", dismissable = true}) {
    var scalingFactor = 1.0; //Utils.getContentScalingFactor(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              return dismissable;
            },
            child: Dialog(
              child: Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(AppPadding.p12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: AppPadding.p12 * scalingFactor,
                    ),
                    Text(
                      customMessage,
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showSnackBar(
    String? message,
    BuildContext context, {
    String? type,
    Widget? content,
    bool autoClose = true,
  }) {
    // type should be error, success and warning and info
    type ??= 'info';
    message ??= '';
    type = type.toLowerCase();
    Color color = Colors.blue;
    switch (type) {
      case 'success':
        color = Colors.green;
        break;
      case 'warning':
        color = Colors.amber;
        break;
      case 'error':
        color = Colors.red;
        break;
      case 'info':
        color = Colors.blue;
        break;
    }
    ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? ctrl;
    final snackBar = SnackBar(
      content: content != null ? Container(child: content) : Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 60),
      action: SnackBarAction(
          label: "Close",
          textColor: Colors.white70,
          onPressed: () {
            ctrl?.close();
          }),
    );

    ctrl = ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // auto close if snackbar is successType
    if (autoClose && type != "error") {
      Timer(const Duration(milliseconds: 3000), () => ctrl?.close());
    }
  }

  static void showFeatureToast(String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

Widget _infoSpaceWidget(
    String title, String subTitile, BuildContext context, VoidCallback onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white, // Background color of the container
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1), // Shadow color
          blurRadius: 1, // Blur radius
        ),
      ],
      borderRadius: BorderRadius.circular(10), // Optional: Adds rounded corners
    ),
    padding: const EdgeInsets.symmetric(
        vertical: AppPadding.p20, horizontal: AppPadding.p20),
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(SvgAssets.personalSpaceIcon),
          const Gap(20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: FontSizes.s14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: Color(0xff5D5D5D)),
                ),
                const Gap(10),
                Text(
                  subTitile,
                  style: const TextStyle(
                      fontSize: FontSizes.s12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Color(0xff5D5D5D)),
                ),
                const Gap(10),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

PageRouteBuilder<dynamic> slidePageTransition(Widget widget,
    {required bool formLeft,
    required bool fromRight,
    required bool fromTop,
    required bool bottom}) {
  return PageRouteBuilder(
    transitionDuration: Duration(
      seconds: 1,
    ),
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        SlideTransition(
      position: Tween<Offset>(
        begin: Offset(
          formLeft
              ? -1
              : fromRight
                  ? 1
                  : 0,
          fromTop
              ? -1
              : bottom
                  ? 1
                  : 0,
        ),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Easing.legacy,
          reverseCurve: Easing.emphasizedDecelerate,
        ),
      ),
      child: child,
    ),
  );
}

Widget imageRenderer({
  required String image,
  required double height,
  required double width,
  required BoxFit fit,
}) {
  try {
    return SvgPicture.network(
      image,
      fit: fit,
      height: height,
      width: width,
    );
  } catch (e) {
    print('Error loading SVG image: $e');
    return CustomImageNetwork(
      imageUrl: image,
      boxFit: fit,
      height: height,
      width: width,
    );
  }
}
