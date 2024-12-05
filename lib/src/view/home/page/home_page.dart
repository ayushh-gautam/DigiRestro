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
            title: CustomText(
                size: 14.h,
                text:
                    "Welcome ${widget.userCredential.user?.displayName ?? ''}"),
            actions: [
              ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Image.network(
                  widget.userCredential.user?.photoURL ??
                      'https://i.pinimg.com/736x/01/de/87/01de8790415df8a899fb0420458c4a9c.jpg',
                  height: 40,
                  width: 40,
                ),
              ).addMargin(EdgeInsets.all(5.h)),
              Gap(5.h)
            ],
          ),
          bottomNavigationBar: HomeBottomSheet(
            tableNumber: widget.currentTableNumber,
          ),
          drawer: HomeDrawer(),
          body: SafeArea(
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: CustomText(text: widget.currentTableNumber.toString()),
              ),
              BlocBuilder<ItemsCubit, ItemsState>(
                builder: (context, state) {
                  if (state is ItemsLoaded) {
                    return TableCardGrid(
                      listOfTables: state.modelList,
                    );
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
