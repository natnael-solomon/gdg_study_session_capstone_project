// lib/product.dart
class Product {
  final String name;
  final double price;
  final String imagePath;
  final double rating;
  final int reviews;
  final String description;
  bool isFavorite;
  bool isInCart;
  final String category; // <-- Add this


  Product({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.rating,
    required this.reviews,
    required this.description,
    this.isFavorite = false,
    this.isInCart = false,
        required this.category, // <-- Add this

  });
}
