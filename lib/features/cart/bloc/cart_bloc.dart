import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:shop_lite/features/cart/data/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final box = Hive.box('cart_box');

  CartBloc() : super(CartLoaded([], 0)) {
    on<LoadCart>(_loadCart);
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
    on<UpdateQuantity>(_updateQuantity);
    on<ClearCart>(_clearCart);
  }

  void _loadCart(LoadCart event, Emitter<CartState> emit) {
    final items = box.values
        .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    emit(CartLoaded(items, _calculateTotal(items)));
  }

  void _addToCart(AddToCart event, Emitter<CartState> emit) {
    final existing = box.get(event.item.id);

    if (existing != null) {
      final item = CartItem.fromMap(Map<String, dynamic>.from(existing));
      item.quantity += 1;
      box.put(event.item.id, item.toMap());
    } else {
      box.put(event.item.id, event.item.toMap());
    }

    add(LoadCart());
  }

  void _removeFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    box.delete(event.id);
    add(LoadCart());
  }

  void _updateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final existing = box.get(event.id);

    if (existing != null) {
      final item = CartItem.fromMap(Map<String, dynamic>.from(existing));
      item.quantity = event.quantity;
      box.put(event.id, item.toMap());
    }

    add(LoadCart());
  }

  void _clearCart(ClearCart event, Emitter<CartState> emit) {
    box.clear();
    add(LoadCart());
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }
}
