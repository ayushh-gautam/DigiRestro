part of 'items_cubit.dart';

sealed class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

final class ItemsInitial extends ItemsState {}

final class ItemsLoaded extends ItemsState {
  final List<ItemModel> modelList;

  ItemsLoaded({required this.modelList});

  @override
  List<Object> get props => [modelList];
}
