import 'package:flutter/foundation.dart';

import 'food_data.dart';

class FoodAppState extends ChangeNotifier {
  bool _signedIn = false;
  String? _email;
  String _address = 'Оберіть адресу доставки';
  final List<CartLine> _cart = [];
  final List<FoodOrder> _orders = [];

  bool get signedIn => _signedIn;
  String? get email => _email;
  String get address => _address;
  List<CartLine> get cart => List.unmodifiable(_cart);
  List<FoodOrder> get orders => List.unmodifiable(_orders);
  int get itemCount => _cart.fold(0, (sum, line) => sum + line.quantity);
  int get total =>
      _cart.fold(0, (sum, line) => sum + line.dish.price * line.quantity);

  void signIn(String email) {
    _signedIn = true;
    _email = email;
    notifyListeners();
  }

  void signOut() {
    _signedIn = false;
    _email = null;
    notifyListeners();
  }

  void add(Restaurant restaurant, Dish dish) {
    final index = _cart.indexWhere((line) => line.dish.id == dish.id);
    if (index == -1) {
      _cart.add(CartLine(restaurant: restaurant, dish: dish, quantity: 1));
    } else {
      _cart[index] = _cart[index].copyWith(quantity: _cart[index].quantity + 1);
    }
    notifyListeners();
  }

  void changeQuantity(Dish dish, int delta) {
    final index = _cart.indexWhere((line) => line.dish.id == dish.id);
    if (index < 0) return;
    final quantity = _cart[index].quantity + delta;
    if (quantity <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index] = _cart[index].copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void placeOrder() {
    if (_cart.isEmpty) return;
    _orders.insert(
      0,
      FoodOrder(
        id: 'FD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        items: List.unmodifiable(_cart),
        total: total,
        address: _address,
        createdAt: DateTime.now(),
        completed: false,
      ),
    );
    _cart.clear();
    notifyListeners();
  }

  void completeOrder(String id) {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(completed: true);
      notifyListeners();
    }
  }
}
