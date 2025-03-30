import 'package:DigiRestro/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/src/repository/cart/cart_cubit.dart';
import 'package:DigiRestro/src/view/order/pages/order_detail_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    context.read<CartCubit>().getOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Order History'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          var orderData = context.read<CartCubit>().orderHistoryModel;
          var orderIds = context.read<CartCubit>().docIds;

          return ListView.builder(
            itemCount: orderData.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                shape: Border(
                  bottom: BorderSide(color: AppColor.black),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetailPage(orderData[index], orderIds[index]),
                      ));
                },
                title: CustomText(
                    text:
                        "Table Number : ${orderData[index].tableNumber ?? ''}"),
                trailing: CustomText(
                    text: "Status : ${orderData[index].orderStatus ?? ''}"),
              );
            },
          );
        },
      ),
    );
  }
}
