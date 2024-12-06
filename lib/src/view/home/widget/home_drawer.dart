// ignore: must_be_immutable
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
  // TextEditingController tableNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // firebase_storage.FirebaseStorage myStorage =
    //     firebase_storage.FirebaseStorage.instance;
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
            ListTile(
              title: CustomText(text: 'Log Out'),
              onTap: () {
                context.read<LoginBloc>().add(OnGoogleLogout(context: context));
              },
            ),
            Gap(50.h)
          ],
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
      title: CustomText(text: title),
    );
  }
}
