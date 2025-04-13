import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capstone_landing_page_project/models/user.dart';
import 'package:capstone_landing_page_project/models/products.dart';
import 'package:capstone_landing_page_project/ProductDetailScreen.dart';
Future<Products> fetchProduct(int productId) async {
  final url = Uri.parse("https://fakestoreapi.com/products/$productId");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Products.fromJson(data);
  } else {
    throw Exception("Failed to load user");
  }
}

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({Key? key, required this.productId}): super(key : key);
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Products> getProduct;
  @override
  void initState() {
    super.initState();
    getProduct = fetchProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<Products>(
        future: getProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return Stack(
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
                            child: Image.network(
                              products.image,
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
                          // Positioned(
                          //   top: 50,
                          //   right: 16,
                          //   child: CircleAvatar(
                          //     backgroundColor: Colors.black.withOpacity(0.4),
                          //     child: IconButton(
                          //       icon: Icon(
                          //         isFavorite
                          //             ? Icons.favorite
                          //             : Icons.favorite_border,
                          //         color: Colors.white,
                          //       ),
                          //       onPressed: () {
                          //         setState(() {
                          //           isFavorite = !isFavorite;
                          //           widget.product.isFavorite = isFavorite;
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                products.title,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "\$${products.price}",
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
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              products.rating.rate.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "(${products.rating.count} Review)",
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          products.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                      if ([
                        "shoes",
                        "hoodie",
                        "clothing",
                      ].contains(products.category.toLowerCase())) ...[
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
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16),
                        //   child: Wrap(
                        //     spacing: 12,
                        //     children:
                        //         getSizesForCategory(product.category).map((
                        //           size,
                        //         ) {
                        //           bool disabled = size == "40";
                        //           return buildSizeChip(
                        //             size,
                        //             disabled: disabled,
                        //           );
                        //         }).toList(),
                        //   ),
                        // ),
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
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
                        // GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       isInCart = !isInCart;
                        //       widget.product.isInCart = isInCart;
                        //     });
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(12),
                        //     decoration: BoxDecoration(
                        //       color:
                        //           isInCart
                        //               ? Color.fromARGB(255, 88, 20, 248)
                        //               : Colors.grey[200],
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     child: Icon(
                        //       isInCart
                        //           ? Icons.shopping_bag
                        //           : Icons.shopping_bag_outlined,
                        //       color: isInCart ? Colors.white : Colors.black,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text("errror");
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // currentIndex: _selectedIndex,
        // onTap: -onItemTapped,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: const Color.fromARGB(255, 91, 87, 87),
            ),
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
