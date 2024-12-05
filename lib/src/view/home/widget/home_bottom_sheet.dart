import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:DigiRestro/commons/controls/custom_button.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openBottomSheet(context, widget.tableNumber);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20.h,
            ),
            border: Border(
                top: BorderSide(
              color: AppColor.greyText,
            ))),
        child: Column(
          children: [
            Gap(5.h),
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                  // border: Border.all(),
                  color: AppColor.greyText,
                  borderRadius: BorderRadius.circular(200)),
            ),
            CustomText(text: 'CART')
          ],
        ),
      ),
    );
  }

  void openBottomSheet(
    BuildContext context,
    int tableNumber,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // This is the content of the bottom sheet
          return Container(
            padding: EdgeInsets.all(16.0.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Current order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.h,
                  ),
                ),
                SizedBox(height: 16.0.h),
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    var cartList = context.read<CartCubit>().cartList;
                    return Expanded(
                      // height: 300.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cartList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: CustomText(text: cartList[index].name ?? ''),
                            subtitle: CustomText(
                                size: 12.h, text: cartList[index].price ?? ''),
                            trailing: IconButton(
                                onPressed: () {
                                  context
                                      .read<CartCubit>()
                                      .removeFromCart(cartList[index]);
                                },
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                )),
                          );
                        },
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    CustomButton(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Create an AlertDialog
                            return AlertDialog(
                              title: const Text('Confirmation'),
                              // content: CustomTextField(
                              //     borderSide: BorderSide(),
                              //     hintText: 'Enter the Table Number',
                              //     controller: tableNumberController),
                              actions: [
                                // Add buttons to the dialog
                                TextButton(
                                  onPressed: () {
                                    // Dismiss the dialog when the "Cancel" button is pressed
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<CartCubit>()
                                        .confirmOrder(tableNumber.toString());
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
                    Gap(10.h),
                    CustomButton(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Create an AlertDialog
                            return AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text(
                                  'Are you sure you want to clear cart?'),
                              actions: [
                                // Add buttons to the dialog
                                TextButton(
                                  onPressed: () {
                                    // Dismiss the dialog when the "Cancel" button is pressed
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
                )
              ],
            ),
          );
        });
  }
}
