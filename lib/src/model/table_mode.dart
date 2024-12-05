// To parse this JSON data, do
//
//     final tableModel = tableModelFromJson(jsonString);

import 'dart:convert';

List<TableModel> tableModelFromJson(String str) =>
    List<TableModel>.from(json.decode(str).map((x) => TableModel.fromJson(x)));

String tableModelToJson(List<TableModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TableModel {
  int? tableNumber;

  TableModel({
    this.tableNumber,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
        tableNumber: json["table_number"],
      );

  Map<String, dynamic> toJson() => {
        "table_number": tableNumber,
      };
}
