import 'package:flutter/material.dart';
import 'package:capstone/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool isFavorite;
  late bool isInCart;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFavorite;
    isInCart = widget.product.isInCart;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        product.imagePath,
                        width: double.infinity,
                        height: 320,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.4),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              widget.product.isFavorite = isFavorite;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 88, 20, 248),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${product.reviews} Review)",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    product.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                ),
                if ([
                  "shoes",
                  "hoodie",
                  "clothing",
                ].contains(product.category.toLowerCase())) ...[
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Size",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 12,
                      children:
                          getSizesForCategory(product.category).map((size) {
                            bool disabled = size == "40";
                            return buildSizeChip(size, disabled: disabled);
                          }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Buy Now logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 88, 20, 248),

                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 12, 11, 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isInCart = !isInCart;
                        widget.product.isInCart = isInCart;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isInCart
                                ? Color.fromARGB(255, 88, 20, 248)
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isInCart
                            ? Icons.shopping_bag
                            : Icons.shopping_bag_outlined,
                        color: isInCart ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> getSizesForCategory(String category) {
    final lower = category.toLowerCase();
    if (lower == "shoes") {
      return ["38", "39", "40", "41"];
    } else if (lower == "hoodie" || lower == "clothing") {
      return ["S", "M", "L", "XL"];
    }
    return [];
  }

  Widget buildSizeChip(String size, {bool disabled = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: disabled ? Colors.grey : Colors.black),
        borderRadius: BorderRadius.circular(12),
        color: disabled ? Colors.grey.shade200 : Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child:
          disabled
              ? Stack(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Text(size, style: const TextStyle(fontSize: 16)),
                  ),
                  const Positioned.fill(
                    child: Center(
                      child: Icon(Icons.block, size: 16, color: Colors.grey),
                    ),
                  ),
                ],
              )
              : Text(size, style: const TextStyle(fontSize: 16)),
    );
  }
}
