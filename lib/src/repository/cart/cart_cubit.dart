import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:DigiRestro/src/model/item_model.dart' as I_M;
import 'package:DigiRestro/src/model/order_history_model.dart';
import 'package:flutter/foundation.dart';

part 'cart_state.dart';

// The CartCubit class manages the state and actions related to the cart and order management.
class CartCubit extends Cubit<CartState> {
  CartCubit(this._firestore) : super(CartInitial());

  // Firestore instance for interacting with the database.
  final FirebaseFirestore _firestore;

  // List to maintain items in the cart.
  List<I_M.ItemModel> cartList = [];

  /// Adds an item to the cart and updates the state.
  Future addToCart(I_M.ItemModel? item) async {
    if (item != null) {
      cartList.add(item);
      emit(AddToCart(
          number: Random()
              .nextInt(100))); // Emits a new state with a random number.
      print(cartList); // Debugging: Prints the updated cart list.
    }
  }

  /// Removes an item from the cart and updates the state.
  Future removeFromCart(I_M.ItemModel? item) async {
    if (item != null) {
      cartList.remove(item);
      emit(AddToCart(number: Random().nextInt(100)));
      if (kDebugMode) {
        print(cartList);
      } // Debugging: Prints the updated cart list.
    }
  }

  /// Clears all items from the cart and updates the state.
  Future removeAll() async {
    cartList.clear();
    emit(AddToCart(number: Random().nextInt(100)));
    if (kDebugMode) {
      print(cartList);
    } // Debugging: Prints the cleared cart list.
  }

  /// Confirms the order by saving it to the Firestore database.
  Future confirmOrder(String tableNumber) async {
    _firestore.collection('OrderHistory').doc().set({
      "tableNumber": tableNumber,
      "orderStatus": "pending",
      "ItemList":
          cartList.map((e) => e.toJson()) // Converts cart items to JSON.
    });
  }

  // Variables for tracking order status and details.
  String currentOrderId = '';
  OrderHistoryModel? orderHistoryData;

  /// Retrieves the status of an order based on its ID.
  String? getOrderStatus(orderId) {
    if (orderId == currentOrderId) {
      return orderHistoryData?.orderStatus ??
          ''; // Returns the order status if it matches the current order.
    } else {
      return null; // Returns null if the order ID does not match.
    }
  }

  /// Marks an order as finished by updating its status to "Paid" in Firestore.
  Future finishOrder(String orderId) async {
    _firestore
        .collection('OrderHistory')
        .doc(orderId)
        .update({'orderStatus': "Paid"}); // Updates the order status.

    if (kDebugMode) {
      print('done');
    } // Debugging: Prints confirmation of the update.

    var response = await FirebaseFirestore.instance
        .collection('OrderHistory')
        .doc(orderId)
        .get(); // Retrieves the updated order details.

    orderHistoryData = OrderHistoryModel.fromJson(
        response.data()!); // Parses the data into an OrderHistoryModel.
    if (kDebugMode) {
      print(orderHistoryData);
    } // Debugging: Prints the updated order data.

    currentOrderId = orderId; // Sets the current order ID.
    emit(AddToCart(number: Random().nextInt(100))); // Emits a new state.
  }

  // List to maintain the history of orders.
  List<OrderHistoryModel> orderHistoryModel = [];

  // List to store document IDs of Firestore entries.
  List<String> docIds = [];

  /// Retrieves the history of paid orders from Firestore.
  Future<List<OrderHistoryModel>> getOrderHistory() async {
    docIds.clear(); // Clears the document IDs list.

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('OrderHistory')
        .where(
          "orderStatus",
          isEqualTo: "Paid",
        )
        .get(); // Queries for orders with the status "Paid".

    var data = querySnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return OrderHistoryModel.fromJson(
          data); // Maps Firestore data to OrderHistoryModel.
    }).toList();

    // Extracts document IDs for each order.
    querySnapshot.docs.forEach((doc) {
      docIds.add(doc.id);
    });

    orderHistoryModel = data; // Updates the local order history list.
    emit(AddToCart(number: Random().nextInt(100))); // Emits a new state.
    return data; // Returns the list of order history models.
  }

  /// Retrieves all orders from Firestore regardless of status.
  Future<List<OrderHistoryModel>> getOrders() async {
    docIds.clear(); // Clears the document IDs list.

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('OrderHistory')
        .get(); // Queries all orders.

    var data = querySnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return OrderHistoryModel.fromJson(
          data); // Maps Firestore data to OrderHistoryModel.
    }).toList();

    // Extracts document IDs for each order.
    querySnapshot.docs.forEach((doc) {
      docIds.add(doc.id);
    });

    orderHistoryModel = data; // Updates the local order history list.
    emit(AddToCart(number: Random().nextInt(100))); // Emits a new state.
    return data; // Returns the list of all orders.
  }
}
