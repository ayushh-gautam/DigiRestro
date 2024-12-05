
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DigiRestro/src/model/item_model.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit(
    this._firestore,
  ) : super(ItemsInitial());

  /// Firestore instance for database operations.
  final FirebaseFirestore _firestore;

  /// Create a new item and add it to the Firestore database.
  Future<void> createItems(
      String name, String category, String price, String? image) async {
    await _firestore.collection('Menu').doc().set(
          ItemModel(
            name: name,
            category: category,
            image: image ?? '',
            price: price,
          ).toJson(),
        );
  }

  // List<ItemModel> itemsData = [];

  /// Retrieve items from the Firestore database.
  Future<void> getItems() async {
    var data = await _firestore.collection('Menu').get();

    var listIterableModel = data.docs.map((e) {
      List<ItemModel> itemsData = [];

      var data3 = ItemModel.fromJson(e.data());
      itemsData.add(data3);
      return itemsData;
    });
    // this expand is use to get list from Iterable<List<ItemModel>>
    var finalModel = listIterableModel.expand((element) => element).toList();

    emit(ItemsLoaded(modelList: finalModel));
  }
}
