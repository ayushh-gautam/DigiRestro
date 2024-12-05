// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  String? tableNumber;
  String? orderStatus;
  List<ItemModel>? itemModel;

  OrderHistoryModel({
    this.tableNumber,
    this.orderStatus,
    this.itemModel,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        tableNumber: json["tableNumber"],
        orderStatus: json["orderStatus"],
        itemModel: json["ItemList"] == null
            ? []
            : List<ItemModel>.from(
                json["ItemList"]!.map((x) => ItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tableNumber": tableNumber,
        "orderStatus": orderStatus,
        "ItemList": itemModel == null
            ? []
            : List<dynamic>.from(itemModel!.map((x) => x.toJson())),
      };
}

class ItemModel {
  String? name;
  String? price;
  String? image;
  String? category;

  ItemModel({
    this.name,
    this.price,
    this.image,
    this.category,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        name: json["name"],
        price: json["price"],
        image: json["image"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "image": image,
        "category": category,
      };
}
