part of 'table_cubit.dart';

enum TableStatus { initial, loading, loaded }

class TableState extends Equatable {
  const TableState(
      {this.tableStatus = TableStatus.initial,
      this.tableData,
      this.bookedIds,
      this.orderHistoryModel});
  final TableStatus tableStatus;
  final List<String>? bookedIds;

  final List<TableModel>? tableData;
  final List<OrderHistoryModel>? orderHistoryModel;
  // final List<String> bookedYableId;

  TableState copyWith(
      {TableStatus? tableStatus,
      List<TableModel>? tableData,
      List<OrderHistoryModel>? orderHistoryModel,
      List<String>? bookedIds}) {
    return TableState(
        tableStatus: tableStatus ?? this.tableStatus,
        bookedIds: bookedIds ?? this.bookedIds,
        orderHistoryModel: orderHistoryModel ?? this.orderHistoryModel,
        tableData: tableData ?? this.tableData);
  }

  @override
  List<Object?> get props =>
      [tableStatus, tableData, orderHistoryModel, bookedIds];
}
