import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class UserRepository {
  static const _cartKey = 'cartItems';
  static const _favoritesKey = 'favorites';
  static const _preferencesKey = 'preferences';
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception(
        'UserRepository not initialized. Call initialize() first.',
      );
    }
    return _prefs!;
  }

  static Future<List<Product>> getCartItems() async {
    final jsonString = _instance.getString(_cartKey);
    if (jsonString == null) return [];

    try {
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      print('Error parsing cart items: $e');
      return [];
    }
  }

  static Future<void> saveCartItems(List<Product> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _instance.setString(_cartKey, json.encode(jsonList));
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<void> saveFavorites(List<String> productIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, productIds);
  }

  static Future<Map<String, dynamic>> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_preferencesKey);
    if (jsonString == null) return {};

    try {
      return Map<String, dynamic>.from(json.decode(jsonString));
    } catch (e) {
      print('Error parsing preferences: $e');
      return {};
    }
  }

  static Future<void> savePreferences(Map<String, dynamic> prefs) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(_preferencesKey, json.encode(prefs));
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
