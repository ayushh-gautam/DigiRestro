import 'dart:math';

import 'package:DigiRestro/src/model/order_history_model.dart';
import 'package:DigiRestro/src/model/table_mode.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

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

  Future<void> getTables() async {
    var data = await firestore.collection('table').get();

    var listIterableModel = data.docs.map((e) {
      List<TableModel> tableData = [];

      var data3 = TableModel.fromJson(e.data());
      tableData.add(data3);
      return tableData;
    });
    // this expand is use to get list from Iterable<List<ItemModel>>
    var finalModel = listIterableModel.expand((element) => element).toList();

    emit(
        state.copyWith(tableStatus: TableStatus.loaded, tableData: finalModel));
  }

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
