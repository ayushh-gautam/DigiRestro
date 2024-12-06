part of 'items_cubit.dart';

sealed class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

final class ItemsInitial extends ItemsState {}

final class ItemsLoaded extends ItemsState {
  final List<ItemModel> modelList;
  final List<String>? listOfItemIds;
  final int number;
  ItemsLoaded(
      {required this.modelList,
      required this.listOfItemIds,
      required this.number});

  @override
  List<Object> get props => [modelList, listOfItemIds ?? [], number];
}
