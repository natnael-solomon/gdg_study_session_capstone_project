import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class UserManager extends ChangeNotifier {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() => _instance;

  UserManager._internal();

  static SharedPreferences? _prefs;

  final List<Product> _cartItems = [];
  final Set<int> _favoriteIds = {};

  List<Product> get cartItems => List.unmodifiable(_cartItems);
  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);
  

  static const _cartKey = 'cartItems';
  static const _favoritesKey = 'favorites';
  static const _preferencesKey = 'preferences';

  static Future<void> initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _instance._loadData();
  }

  static SharedPreferences get _instancePrefs {
    if (_prefs == null) {
      throw Exception('UserManager not initialized.');
    }
    return _prefs!;
  }

  Future<void> _loadData() async {
    final cartJson = _instancePrefs.getString(_cartKey);
    final favs = _instancePrefs.getStringList(_favoritesKey) ?? [];

    if (cartJson != null) {
      try {
        final cartList = json.decode(cartJson) as List;
        _cartItems.clear();
        _cartItems.addAll(cartList.map((e) => Product.fromJson(e)));
      } catch (e) {
        print('Cart load error: $e');
      }
    }

    _favoriteIds.clear();
    _favoriteIds.addAll(favs.map(int.parse));

    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    _cartItems.add(product);
    await _saveCart();
    notifyListeners();
  }

  Future<void> removeFromCart(Product product) async {
    _cartItems.removeWhere((p) => p.id == product.id);
    await _saveCart();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final jsonList = _cartItems.map((e) => e.toJson()).toList();
    await _instancePrefs.setString(_cartKey, json.encode(jsonList));
  }

  Future<void> toggleFavorite(int productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  Future<void> _saveFavorites() async {
    await _instancePrefs.setStringList(
      _favoritesKey,
      _favoriteIds.map((e) => e.toString()).toList(),
    );
  }

  Future<Map<String, dynamic>> getPreferences() async {
    final jsonStr = _instancePrefs.getString(_preferencesKey);
    if (jsonStr == null) return {};
    try {
      return Map<String, dynamic>.from(json.decode(jsonStr));
    } catch (e) {
      print('Error loading prefs: $e');
      return {};
    }
  }

  Future<void> savePreferences(Map<String, dynamic> prefs) async {
    await _instancePrefs.setString(_preferencesKey, json.encode(prefs));
  }

  Future<void> clearCart() async {
       _cartItems.clear();
       notifyListeners();
  }

  Future<void> clearAllData() async {
    await _instancePrefs.clear();
    _cartItems.clear();
    _favoriteIds.clear();
    notifyListeners();
  }
}
