import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/core/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:DigiRestro/commons/controls/custom_button.dart';
import 'package:DigiRestro/src/repository/cart/cart_cubit.dart';
import 'package:DigiRestro/utils/app_color.dart';

class HomeBottomSheet extends StatefulWidget {
  const HomeBottomSheet({
    super.key,
    required this.tableNumber,
  });
  final int tableNumber;

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        var cartList = context.read<CartCubit>().cartList;
        return InkWell(
            onTap: () {
              openBottomSheet(context, widget.tableNumber);
            },
            child: Stack(children: [
              Icon(
                size: 30,
                Icons.shopping_bag_rounded,
                color: AppColor.white,
              ),
              (cartList.isNotEmpty)
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          height: 20.h,
                          width: 20.h,
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(300)),
                          child: Center(
                              child: CustomText(
                            color: AppColor.white,
                            text: cartList.length.toString(),
                            size: 12.h,
                          ))),
                    )
                  : SizedBox(),
            ]));
      },
    );
  }

  void openBottomSheet(BuildContext context, int tableNumber) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Current Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0.h,
                  color: AppColor.textColor,
                ),
              ),
              SizedBox(height: 16.0.h),
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  var cartList = context.read<CartCubit>().cartList;
                  return Expanded(
                    child: cartList.isEmpty
                        ? Center(
                            child: Text(
                              'No items in the cart.',
                              style:
                                  TextStyle(fontSize: 16.h, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8.h),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.h),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(12.h),
                                  title: Text(
                                    cartList[index].name ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.h),
                                  ),
                                  subtitle: Text(
                                    cartList[index].price ?? '',
                                    style: TextStyle(
                                      fontSize: 12.h,
                                      color: AppColor.greyText,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      context
                                          .read<CartCubit>()
                                          .removeFromCart(cartList[index]);
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmation'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await context
                                        .read<CartCubit>()
                                        .confirmOrder(
                                            tableNumber.toString(), userName);
                                    Navigator.of(context).pop();
                                    await context.read<CartCubit>().removeAll();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      width: 220.h,
                      text: 'Confirm Order',
                      textColor: AppColor.white,
                    ),
                  ),
                  Gap(10.h),
                  CustomButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation'),
                            content: const Text(
                                'Are you sure you want to clear the cart?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<CartCubit>().removeAll();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    width: 70.h,
                    color: Colors.red,
                    padding: const EdgeInsets.all(0),
                    widget: Icon(
                      Icons.delete,
                      color: AppColor.white,
                    ),
                    textColor: AppColor.white,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
