import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final double price;

  CartItem({required this.name, required this.price});
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total => _items.fold(0.0, (sum, item) => sum + item.price);

  void addItem(String name, double price) {
    _items.add(CartItem(name: name, price: price));
    notifyListeners(); // Triggers UI updates via watch()
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
