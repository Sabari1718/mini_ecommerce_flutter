
import 'package:flutter/material.dart';
import 'product.dart';

class CartItem {
  final Product product;
  int qty;
  CartItem({required this.product, this.qty = 1});
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  void add(Product p) {
    if (_items.containsKey(p.id)) {
      _items[p.id]!.qty += 1;
    } else {
      _items[p.id] = CartItem(product: p, qty: 1);
    }
    notifyListeners();
  }

  void remove(Product p) {
    if (!_items.containsKey(p.id)) return;
    _items.remove(p.id);
    notifyListeners();
  }

  void changeQty(Product p, int qty) {
    if (_items.containsKey(p.id)) {
      if (qty <= 0) _items.remove(p.id);
      else _items[p.id]!.qty = qty;
      notifyListeners();
    }
  }

  double get total {
    double t = 0;
    _items.forEach((k, v) => t += v.product.price * v.qty);
    return t;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
