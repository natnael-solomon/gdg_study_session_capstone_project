import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';
  static const Duration _timeout = Duration(seconds: 15);

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();

  Future<List<Product>> getProducts() async {
    return _handleRequest(
      () => _client.get(Uri.parse('$_baseUrl/products')),
      (data) => (data as List).map((e) => Product.fromJson(e)).toList(),
    );
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    return _handleRequest(
      () => _client.get(Uri.parse('$_baseUrl/products/category/$category')),
      (data) => (data as List).map((e) => Product.fromJson(e)).toList(),
    );
  }

  Future<Product> getProductDetails(int id) async {
    return _handleRequest(
      () => _client.get(Uri.parse('$_baseUrl/products/$id')),
      (data) => Product.fromJson(data),
    );
  }

  Future<List<String>> getCategories() async {
    return _handleRequest(
      () => _client.get(Uri.parse('$_baseUrl/products/categories')),
      (data) => (data as List).map((e) => e.toString()).toList(),
    );
  }


  List<Product> filterAll({
    required List<Product> products,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? maxRating,
    String? category,
    String? searchKeyword,
    int? minReviewCount,
  }) {
    return products.where((p) {
      final withinPrice =
          p.price >= (minPrice ?? 0) &&
          p.price <= (maxPrice ?? double.infinity);
      final withinRating =
          p.rating.rate >= (minRating ?? 0) &&
          p.rating.rate <= (maxRating ?? 5.0);
      final inCategory =
          category == null ||
          category.toLowerCase() == p.category.toLowerCase();
      final matchesSearch =
          searchKeyword == null ||
          p.title.toLowerCase().contains(searchKeyword.toLowerCase());
      final enoughReviews = p.rating.count >= (minReviewCount ?? 0);

      return withinPrice &&
          withinRating &&
          inCategory &&
          matchesSearch &&
          enoughReviews;
    }).toList();
  }

  Future<T> _handleRequest<T>(
    Future<http.Response> Function() request,
    T Function(dynamic) parser,
  ) async {
    try {
      final response = await request().timeout(_timeout);
      return _handleResponse(response, parser);
    } on TimeoutException {
      throw 'Request timed out';
    } on http.ClientException {
      throw 'Network error';
    } catch (e) {
      throw 'Failed to load data';
    }
  }

  T _handleResponse<T>(http.Response response, T Function(dynamic) parser) {
    if (response.statusCode == 200) {
      return parser(json.decode(response.body));
    } else {
      throw 'Server error: ${response.statusCode}';
    }
  }

  void dispose() => _client.close();
}
