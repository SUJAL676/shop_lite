part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;

  CartLoaded(this.items, this.total);
}
