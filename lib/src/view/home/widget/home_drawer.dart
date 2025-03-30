// ignore: must_be_immutable
import 'package:DigiRestro/core/preferences/preferences.dart';
import 'package:DigiRestro/src/view/home/page/table_page.dart';
import 'package:DigiRestro/src/view/home/widget/add_item_page.dart';
import 'package:DigiRestro/src/view/home/widget/delete_item_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:DigiRestro/commons/controls/custom_button.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/commons/controls/custom_textfield.dart';
import 'package:DigiRestro/src/repository/items/items_cubit.dart';
import 'package:DigiRestro/src/repository/login/login_bloc.dart';
import 'package:DigiRestro/src/view/order/pages/current_order.dart';
import 'package:DigiRestro/src/view/order/pages/order_history.dart';
import 'package:DigiRestro/utils/app_color.dart';
import 'package:DigiRestro/utils/extension.dart';

import '../../../repository/image_pick/cubit/image_picker_cubit.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({
    super.key,
    this.userCredential,
  });
  final UserCredential? userCredential;
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String? userName = 'User';
  Future<String?> getUsername() async {
    var username = await Preferences.instance.getString('USER_NAME');
    userName = username;
    return username;
  }

  @override
  void initState() {
    getUsername().then((s) {
      setState(() {});
    });

    super.initState();
  }

  // TextEditingController tableNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // firebase_storage.FirebaseStorage myStorage =
    //     firebase_storage.FirebaseStorage.instance;
    return SafeArea(
      child: Drawer(
        shape: Border(),
        child: Container(
          color: AppColor.newPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 150.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Welcome',
                      color: AppColor.white,
                      fontWeight: FontWeight.w600,
                      size: 30.h,
                    ),
                    CustomText(
                      text: userName ?? 'User',
                      color: AppColor.white,
                      fontWeight: FontWeight.w400,
                      size: 12.h,
                    ),
                    Divider()
                  ],
                ).addMargin(EdgeInsets.all(16.h)),
              ),
              createItem(
                  context: context,
                  navigateTo: CurrentOrderPage(),
                  title: "Current Orders"),
              createItem(
                  context: context,
                  navigateTo: TablePage(
                    userCredential: widget.userCredential,
                    // isTableManagement: true,
                  ),
                  title: "Tables/NewOrders"),
              createItem(
                  context: context,
                  navigateTo: OrderHistoryPage(),
                  title: "Order History"),
              createItem(
                  context: context,
                  navigateTo: AddItemPage(),
                  title: 'Add Item To Menu'),
              createItem(
                  context: context,
                  navigateTo: DeleteItemPage(),
                  title: 'Delete Item From Menu'),
              Spacer(),
              ListTile(
                title: CustomText(
                  text: 'Log Out',
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  context
                      .read<LoginBloc>()
                      .add(OnGoogleLogout(context: context));
                },
              ),
              Gap(50.h)
            ],
          ),
        ),
      ),
    );
  }

  ListTile createItem(
      {required BuildContext context,
      required Widget navigateTo,
      required String title}) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => navigateTo,
            ));
      },
      title: CustomText(
        text: title,
        color: AppColor.white,
      ),
    );
  }
}
