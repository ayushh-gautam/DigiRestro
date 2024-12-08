import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:DigiRestro/commons/controls/custom_button.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/src/model/order_history_model.dart';
import 'package:DigiRestro/src/repository/cart/cart_cubit.dart';
import 'package:DigiRestro/utils/app_color.dart';
import 'package:DigiRestro/utils/extension.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderHistoryModel orderData;
  final String orderId;
  const OrderDetailPage(this.orderData, this.orderId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: orderData.orderStatus != 'Paid'
          ? CustomButton(
              text: 'Complete Order',
              textColor: AppColor.white,
              radius: 12.h,
              onTap: () {
                context.read<CartCubit>().finishOrder(orderId);
              },
            ).addMargin(EdgeInsets.symmetric(horizontal: 10.h))
          : const SizedBox(),
      body: SizedBox(
        height: 800.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: orderData.itemModel?.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: CustomText(
                      text: orderData.itemModel?[index].name ?? 'no name'),
                  trailing: CustomText(
                      text: orderData.itemModel?[index].price ?? 'Price'),
                );
              },
            ),
            const Divider(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: 'Status :'),
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    var orderNewData =
                        context.read<CartCubit>().getOrderStatus(orderId);
                    return CustomText(
                        text: orderNewData ?? orderData.orderStatus ?? '');
                  },
                )
              ],
            ).addMargin(EdgeInsets.symmetric(horizontal: 10.h)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: 'Total :'),
                CustomText(text: totalAmount(orderData.itemModel))
              ],
            ).addMargin(EdgeInsets.symmetric(horizontal: 10.h)),
          ],
        ),
      ),
    );
  }

  String totalAmount(List<ItemModel>? itemModel) {
    if (itemModel?.isNotEmpty ?? false) {
      var totalPrice = 0.00;
      for (var i = 0; i < itemModel!.length; i++) {
// Get the price from the current item, defaulting to 0 if it's null
        var price = double.tryParse(itemModel[i].price ?? '0') ?? 0;

        // Add the price to the total
        totalPrice += price;
      }
      return '$totalPrice';
    } else {
      return '';
    }
  }
}
