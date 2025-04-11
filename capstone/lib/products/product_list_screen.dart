import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'package:capstone/products/product.dart'; // Shared Product model

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
 List<Product> products = [
  Product(
    name: "Watch",
    price: 40,
    imagePath: "assets/images/watch.png",
    rating: 4.2,
    reviews: 12,
    description:
        "Classic analog watch with a stainless steel frame and water-resistant design — perfect for both casual and formal wear.",
    category: "watch",
  ),
  Product(
    name: "Nike Shoes",
    price: 430,
    imagePath: "assets/images/nike_shoes.png",
    rating: 4.5,
    reviews: 20,
    description:
        "Premium Nike running shoes built with breathable mesh, responsive cushioning, and superior grip for all-day comfort.",
    category: "shoes",
  ),
  Product(
    name: "LG TV",
    price: 330,
    imagePath: "assets/images/Lg_tv.png",
    rating: 4.1,
    reviews: 8,
    description:
        "Experience stunning visuals with this 55-inch Ultra HD LG Smart TV featuring vibrant colors, crisp resolution, and built-in streaming apps.",
    category: "tv",
  ),
  Product(
    name: "Airpods",
    price: 333,
    imagePath: "assets/images/airpods.png",
    rating: 4.7,
    reviews: 34,
    description:
        "True wireless Apple AirPods with active noise cancellation, crystal-clear sound, and seamless connectivity with all your devices.",
    category: "earphones",
  ),
  Product(
    name: "Jacket",
    price: 50,
    imagePath: "assets/images/jacket.png",
    rating: 4.0,
    reviews: 15,
    description:
        "Durable and windproof outdoor jacket made from high-quality fabric — ideal for hiking, travel, or everyday winter wear.",
    category: "clothing",
  ),
  Product(
    name: "Hoodie",
    price: 400,
    imagePath: "assets/images/hoodie.png",
    rating: 4.3,
    reviews: 18,
    description:
        "Cozy unisex fleece hoodie with a kangaroo pocket and adjustable hood — your go-to piece for warmth and laid-back style.",
    category: "hoodie",
  ),
  Product(
    name: "Sunglass",
    price: 150,
    imagePath: "assets/images/sunglass.png",
    rating: 4.4,
    reviews: 10,
    description:
        "Trendy UV400-protected sunglasses with polarized lenses and a sleek frame — combining fashion with full eye protection.",
    category: "sunglass",
  ),
  Product(
    name: "All-in-One Bundle",
    price: 75,
    imagePath: "assets/images/all.png",
    rating: 4.6,
    reviews: 22,
    description:
        "A smart value pack featuring essentials including a hoodie, shades, and accessories — all bundled for your lifestyle needs.",
    category: "bundle",
  ),
];


  void toggleFavorite(int index) {
    setState(() {
      products[index].isFavorite = !products[index].isFavorite;
    });
  }

  void toggleCart(int index) {
    setState(() {
      products[index].isInCart = !products[index].isInCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.70,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              image: DecorationImage(
                                image: AssetImage(product.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => toggleFavorite(index),
                              child: Icon(
                                product.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    product.isFavorite
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product name only
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          // Row with price and cart icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${product.price}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100,
                                  color: const Color.fromARGB(255, 88, 20, 248),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => toggleCart(index),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 88, 20, 248),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    product.isInCart ? Icons.check : Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
