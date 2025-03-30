import 'package:DigiRestro/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/src/repository/items/items_cubit.dart';
import 'package:DigiRestro/src/view/home/widget/home_drawer.dart';
import 'package:DigiRestro/src/view/home/widget/table_card.dart';
import 'package:DigiRestro/utils/extension.dart';
import '../widget/home_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      required this.userCredential,
      required this.currentTableNumber});
  final UserCredential userCredential;
  final int currentTableNumber;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ItemsCubit>().getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<ItemsCubit>().getItems();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.newPrimary, // Use a vibrant color
            title: CustomText(
                size: 16.h,
                text: "Menu",
                fontWeight: FontWeight.bold, // Bolder font
                color: Colors.white),
            actions: [
              HomeBottomSheet(
                tableNumber: widget.currentTableNumber,
              ).addMargin(EdgeInsets.all(8.h)),
              Gap(8.h)
            ],
          ),
          drawer: HomeDrawer(
            userCredential: widget.userCredential,
          ),
          body: SafeArea(
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.all(16.h),
                    height: 60.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColor.backButtonBg, AppColor.newPrimary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.h),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ]),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: CustomText(
                      text:
                          "Current Table ${widget.currentTableNumber.toString()}",
                      fontWeight: FontWeight.w600,
                      size: 20.h,
                      color: Colors.white,
                    )),
              ),
              BlocBuilder<ItemsCubit, ItemsState>(
                builder: (context, state) {
                  if (state is ItemsLoaded) {
                    if (state.modelList.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: CustomText(
                              text: 'No menu available',
                              fontWeight: FontWeight.w500,
                              size: 18.h),
                        ),
                      );
                    } else {
                      return TableCardGrid(
                        listOfTables: state.modelList,
                      );
                    }
                  } else {
                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
                  }
                },
              ),
              SliverToBoxAdapter(child: Gap(20.h)),
            ]).addMargin(EdgeInsets.symmetric(horizontal: 16)),
          )),
    );
  }
}
