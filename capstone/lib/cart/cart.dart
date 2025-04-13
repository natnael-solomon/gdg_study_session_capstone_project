import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Color primaryColor = const Color(0xFF9C6EF3);
  final Color greyColor = const Color(0xFFEEEEEE);

  List<Map<String, dynamic>> cartItems = [
    {
      'imageUrl': 'assets/images/four.png',
      'title': 'Watch',
      'brand': 'Rolex',
      'price': 40,
      'quantity': 2,
    },
    {
      'imageUrl': 'assets/images/five.png',
      'title': 'Airpods',
      'brand': 'Apple',
      'price': 333,
      'quantity': 1,
    },
    {
      'imageUrl': 'assets/images/six.png',
      'title': 'Hoodie',
      'brand': 'Puma',
      'price': 50,
      'quantity': 1,
    },
  ];

  void _updateQuantity(int index, int change) {
    setState(() {
      cartItems[index]['quantity'] += change;
      if (cartItems[index]['quantity'] < 1) {
        cartItems[index]['quantity'] = 1;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Clear Cart"),
        content: Text("Are you sure you want to clear the cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                cartItems.clear();
              });
              Navigator.pop(context);
            },
            child: Text("Clear"),
          ),
        ],
      ),
    );
  }

  Widget buildCartItem(int index) {
    final item = cartItems[index];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item['imageUrl'],
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'],
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(item['brand'], style: TextStyle(color: Colors.grey)),
                Text('\$${item['price']}',
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () => _updateQuantity(index, -1),
                borderRadius: BorderRadius.circular(20),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: greyColor,
                  child: Icon(Icons.remove, size: 16, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(item['quantity'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              InkWell(
                onTap: () => _updateQuantity(index, 1),
                borderRadius: BorderRadius.circular(20),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _removeItem(index),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 16 : 14)),
          Text(value,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 16 : 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalItems =
    cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
    final subtotal = cartItems.fold<double>(
      0,
          (sum, item) => sum + (item['price'] as num) * (item['quantity'] as int),
    );

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Cart",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, size: 28),
                    onSelected: (String value) {
                      if (value == 'Clear Cart') {
                        _clearCart();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Clear Cart',
                        child: Text('Clear Cart'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: cartItems.isNotEmpty
                    ? ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) =>
                      buildCartItem(index),
                )
                    : Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    buildSummaryRow("Items", totalItems.toString()),
                    buildSummaryRow(
                        "Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                    buildSummaryRow("Discount", "\$4"),
                    buildSummaryRow("Delivery Charges", "\$2"),
                    Divider(),
                    buildSummaryRow(
                      "Total",
                      "\$${(subtotal - 4 + 2).toStringAsFixed(2)}",
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                  EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Check Out",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
