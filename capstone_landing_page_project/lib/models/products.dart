import 'dart:convert';

class Products {
  final int id;
  final String description;
  final String title;
  final double price;
  final Rating rating;
  final String category;
  final String image;
  Products({
    required this.id,
    required this.description,
    required this.title,
    required this.price,
    required this.rating,
    required this.category,
    required this.image,
  });
  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      description: json['description'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      rating: Rating.fromJson(json['rating']),
      category: json['category'],
      image: json['image'],
    );
  }
}

class Rating {
  final double rate;
  final int count;
  Rating({required this.rate, required this.count});
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(), 
      count: json['count']
      );
  }
}
