import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_color.dart';

// ignore: must_be_immutable
class CustomTabBar extends StatefulWidget {
  CustomTabBar({
    Key? key,
    required this.tabList,
    required this.controller,
  }) : super(key: key);
  final List<Widget> tabList;
  late TabController controller;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  var itemIndex = 0;
  // int activeTabIndex = 1;

  @override
  void initState() {
    super.initState();
    widget.controller = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
    widget.controller.addListener(() {
      if (kDebugMode) {
        print(widget.controller.index);
      }
      setState(() {
        itemIndex = widget.controller.index;
      });
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return TabBar(
        controller: widget.controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelStyle: GoogleFonts.poppins(
            color: AppColor.white, fontSize: 14.h, fontWeight: FontWeight.w400),
        dividerColor: AppColor.white,
        automaticIndicatorColorAdjustment: true,
        indicatorColor: AppColor.newPrimary,
        unselectedLabelColor: AppColor.greyText,
        indicator: BoxDecoration(
            color: AppColor.newPrimary,
            borderRadius: BorderRadius.circular(200.w)),
        indicatorSize: TabBarIndicatorSize.label,
        splashBorderRadius: BorderRadius.circular(200.h),
        splashFactory: NoSplash.splashFactory,
        // indicatorPadding: EdgeInsets.symmetric(horizontal: 0.h, vertical: 4.h),
        padding: const EdgeInsets.only(left: 0),
        // onTap: (index) {
        //   itemIndex = index;
        //   setState(() {});
        //   print(itemIndex);
        // },
        tabs: [
          ...List.generate(
            2,
            (index) => Tab(
                child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 0.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: itemIndex == index
                      ? AppColor.newPrimary
                      : const Color(0xFFF6F7F9),
                  borderRadius: BorderRadius.circular(200.h)),
              child: const Text("About"),
            )),
          )

          // Tab(
          //   child: Container(
          //     height: 40.h,
          //     padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //         color: Color(0xFFF6F7F9),
          //         borderRadius: BorderRadius.circular(200.h)),
          //     child: Text("What's covered"),
          //   ),
          //   // text: "What's covered",
          // ),
        ]);
  }
}
