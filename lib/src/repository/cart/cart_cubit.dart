import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:DigiRestro/src/model/item_model.dart' as I_M;
import 'package:DigiRestro/src/model/order_history_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._firestore) : super(CartInitial());
  final FirebaseFirestore _firestore;
  List<I_M.ItemModel> cartList = [];
  Future addToCart(I_M.ItemModel? item) async {
    if (item != null) {
      cartList.add(item);
      emit(AddToCart(number: Random().nextInt(100)));
      print(cartList);
    }
  }

  Future removeFromCart(I_M.ItemModel? item) async {
    if (item != null) {
      cartList.remove(item);
      emit(AddToCart(number: Random().nextInt(100)));
      print(cartList);
    }
  }

  Future removeAll() async {
    cartList.clear();
    emit(AddToCart(number: Random().nextInt(100)));
    print(cartList);
  }

  Future confirmOrder(String tableNumber) async {
    _firestore.collection('OrderHistory').doc().set({
      "tableNumber": tableNumber,
      "orderStatus": "pending",
      "ItemList": cartList.map((e) => e.toJson())
    });
  }
// for getting the status of the order in order detail page

  String currentOrderId = '';
  OrderHistoryModel? orderHistoryData;
  String? getOrderStatus(orderId) {
    if (orderId == currentOrderId) {
      return orderHistoryData?.orderStatus ?? '';
    } else {
      return null;
    }
  }

  Future finishOrder(String orderId) async {
    _firestore
        .collection('OrderHistory')
        .doc(orderId)
        .update({'orderStatus': "Paid"});
    print('done');
    var response = await FirebaseFirestore.instance
        .collection('OrderHistory')
        .doc(orderId)
        .get();

    orderHistoryData = OrderHistoryModel.fromJson(response.data()!);
    print(orderHistoryData);
    currentOrderId = orderId;
    emit(AddToCart(number: Random().nextInt(100)));
  }

  List<OrderHistoryModel> orderHistoryModel = [];

  List<String> docIds = [];
  Future<List<OrderHistoryModel>> getOrderHistory() async {
    docIds.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('OrderHistory').get();

    var data = querySnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return OrderHistoryModel.fromJson(data);
    }).toList();
// to get the id of each doc
    querySnapshot.docs.forEach((doc) {
      docIds.add(doc.id);
    });
    // print(data[0].itemModel![0].name);
    orderHistoryModel = data;
    emit(AddToCart(number: Random().nextInt(100)));
    return data;
  }
}
