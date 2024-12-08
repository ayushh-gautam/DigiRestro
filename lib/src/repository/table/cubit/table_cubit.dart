import 'dart:math';

import 'package:DigiRestro/src/model/order_history_model.dart';
import 'package:DigiRestro/src/model/table_mode.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit({required this.firestore}) : super(TableState());
  final FirebaseFirestore firestore;

  Future setTableInfo(int tableNumber) async {
    await firestore
        .collection('table')
        .doc()
        .set({"table_number": tableNumber});
    print('sett');
    return true;
  }

// we would have done  normal get table data but we wouldn't end up getting the id of that doc
//so we did this to insure the doc is with the model
// this will help us while deleting or editing the table
  Future<void> getTables() async {
    var data = await firestore.collection('table').get();

    // Map documents to TableModel instances
    var tableData = data.docs.map((doc) {
      return TableModel(
        tableId: doc.id, // Set the document ID as tableId
        tableNumber: doc.data()["table_number"], // Extract table_number field
      );
    }).toList();

    // Emit the final data
    emit(
      state.copyWith(
        tableStatus: TableStatus.loaded,
        tableData: tableData, // Final list of TableModel
      ),
    );
  }

//for deleting the specific table
  Future<void> deleteTable(String tableId) async {
    EasyLoading.show(
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: false);
    try {
      // Delete the document from the 'table' collection
      await firestore.collection('table').doc(tableId).delete();

      // Optionally, log success or notify the user
      print("Table with ID $tableId successfully deleted.");

      // Emit updated state if necessary
      // You might want to reload the table data after deletion
      await getTables(); // Re-fetch updated table data
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      // Handle errors
      print("Failed to delete table with ID $tableId: $e");
    }
  }

//
  List<String> docIds = [];
  List<String> bookedIds = [];

  List<OrderHistoryModel> orderHistoryModel = [];
  Future<List<OrderHistoryModel>> getOrders() async {
    docIds.clear();
    bookedIds.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('OrderHistory')
        .where('orderStatus', isEqualTo: "pending")
        .get();

    var data = querySnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return OrderHistoryModel.fromJson(data);
    }).toList();
// to get the id of each doc
    querySnapshot.docs.forEach((doc) {
      docIds.add(doc.id);
      // print(doc.id);
    });
    var mapData = querySnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return data;
    }).toList();

    for (var i = 0; i < mapData.length; i++) {
      var data = mapData[i]['tableNumber'];
      bookedIds.add(data.toString());
    }
    print(bookedIds);

    // print(data[0].itemModel![0].name);
    orderHistoryModel = data;
    emit(state.copyWith(
        orderHistoryModel: orderHistoryModel, bookedIds: bookedIds));
    return data;
  }
}
