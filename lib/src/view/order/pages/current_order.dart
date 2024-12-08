import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/src/repository/cart/cart_cubit.dart';
import 'package:DigiRestro/src/view/order/pages/order_detail_page.dart';

class CurrentOrderPage extends StatefulWidget {
  const CurrentOrderPage({super.key});

  @override
  State<CurrentOrderPage> createState() => _CurrentOrderPageState();
}

class _CurrentOrderPageState extends State<CurrentOrderPage> {
  @override
  void initState() {
    context.read<CartCubit>().getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<CartCubit>().getOrders();
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(text: 'Current Orders'),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            var orderData = context.read<CartCubit>().orderHistoryModel;
            var orderIds = context.read<CartCubit>().docIds;
       
            if (orderData.isEmpty) {
              return Center(
                child: CustomText(text: 'No any status to show here'),
              );
            } else {
              return ListView.builder(
                itemCount: orderData.length,
                itemBuilder: (BuildContext context, int index) {
                  return orderData[index].orderStatus != 'Paid'
                      ? ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(
                                      orderData[index], orderIds[index]),
                                ));
                          },
                          title: CustomText(
                              text:
                                  "Table Number : ${orderData[index].tableNumber ?? ''}"),
                          trailing: CustomText(
                              text:
                                  "Status : ${orderData[index].orderStatus ?? ''}"),
                        )
                      : SizedBox.shrink();
                },
              );
            }
          },
        ),
      ),
    );
  }
}
