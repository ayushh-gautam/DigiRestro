part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class AddToCart extends CartState {
  final int number;

  AddToCart({required this.number});
  @override
  List<Object> get props => [number];
}
