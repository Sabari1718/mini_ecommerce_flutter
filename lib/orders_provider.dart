import 'package:flutter/material.dart';
import 'product.dart';

class OrdersProvider extends ChangeNotifier {
  final List<Product> _orders = [];

  List<Product> get orders => _orders;


  void addOrder(Product product) {
    _orders.add(product);
    notifyListeners();
  }


  void cancelOrder(Product product) {
    _orders.remove(product);
    notifyListeners();
  }
}
