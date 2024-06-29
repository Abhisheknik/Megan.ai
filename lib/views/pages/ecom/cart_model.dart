import 'package:flutter/material.dart';
import 'package:ai_app/models/product.dart';

class CartModel extends ChangeNotifier {
  final List<Product> _items = [];
  final Map<Product, int> _itemCounts = {};

  List<Product> get items => _items;
  int get itemCount => _items.length;

  void addToCart(Product product) {
    if (_itemCounts.containsKey(product)) {
      _itemCounts[product] = (_itemCounts[product] ?? 0) + 1;
    } else {
      _items.add(product);
      _itemCounts[product] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (_itemCounts.containsKey(product)) {
      if (_itemCounts[product] == 1) {
        _items.remove(product);
        _itemCounts.remove(product);
      } else {
        _itemCounts[product] = (_itemCounts[product] ?? 1) - 1;
      }
      notifyListeners();
    }
  }

  int getItemCount(Product product) {
    return _itemCounts[product] ?? 0;
  }

  int get totalPrice {
    int total = 0;
    _itemCounts.forEach((product, count) {
      total += product.price * count;
    });
    return total;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  List<Product> getOrderedProducts() {
    List<Product> orderedProducts = [];
    _items.forEach((product) {
      for (int i = 0; i < _itemCounts[product]!; i++) {
        orderedProducts.add(product);
      }
    });
    return orderedProducts;
  }
}
