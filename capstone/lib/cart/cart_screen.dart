import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../checkout/checkout.dart';
import '../models/product.dart';
import '../services/user_manager.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final UserManager _userManager = UserManager();
  double _total = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();

    _userManager.addListener(_onCartUpdated);
  }

  @override
  void dispose() {
    _userManager.removeListener(_onCartUpdated);
    super.dispose();
  }

  void _onCartUpdated() {
    _calculateTotal();
    if (mounted) setState(() {});
  }

  void _calculateTotal() {
    _total = _userManager.cartItems.fold(0, (sum, item) => sum + item.price);
  }

  Future<void> _removeItem(Product product) async {
    await _userManager.removeFromCart(product);
  }

  Future<void> _checkout() async {
    if (_userManager.cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty!')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckoutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _userManager.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart (${cartItems.length})',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Clear Cart',
              onPressed: () async {
                await _userManager.clearAllData();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                cartItems.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            'Your cart is empty',
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Dismissible(
                          key: Key(item.id.toString()),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) => _removeItem(item),
                          child: ListTile(
                            leading: Image.network(
                              item.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              item.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeItem(item),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_total.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6055D8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF6055D8),
                      ),
                      onPressed: _checkout,
                      child: Text(
                        'Checkout',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
