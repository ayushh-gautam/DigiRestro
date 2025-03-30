import 'package:DigiRestro/utils/app_color.dart';
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
          backgroundColor: AppColor.primaryBlue, // Changed app bar color
          centerTitle: true, // Center the title
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            var orderData = context.read<CartCubit>().orderHistoryModel;
            var orderIds = context.read<CartCubit>().docIds;

            if (orderData.isEmpty) {
              return const Center(
                child: Text(
                  'No orders available at the moment.',
                  style: TextStyle(
                      fontSize: 18, color: Colors.grey), // Updated text style
                ),
              );
            } else {
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.all(16), // Added padding for better spacing
                    itemCount: orderData.length,
                    itemBuilder: (BuildContext context, int index) {
                      var order = orderData[index];
                      var orderId = orderIds[index];
                      return order.orderStatus != 'Paid'
                          ? Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8), // Card margin for spacing
                              elevation: 5, // Shadow for the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners for cards
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailPage(order, orderId),
                                    ),
                                  );
                                },
                                contentPadding: const EdgeInsets.all(
                                    16), // Padding inside the list tile
                                leading: Icon(Icons.receipt_long,
                                    color:
                                        AppColor.primaryBlue), // Added an icon
                                title: Text(
                                    "Table Number: ${order.tableNumber ?? 'N/A'}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    "Status: ${order.orderStatus ?? 'Unknown'} \nOrdered by : ${order.orderBy ?? 'Unknown'}",
                                    style: TextStyle(color: Colors.grey[600])),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
