import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OrdersScreen(),
  ));
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> activeOrders = [
    {
      "title": "Watch",
      "brand": "Rolex",
      "price": "\$40",
      "image": "assets/images/four.png",
    },
    {
      "title": "Airpods",
      "brand": "Apple",
      "price": "\$333",
      "image": "assets/images/five.png",
    },
    {
      "title": "Hoodie",
      "brand": "Puma",
      "price": "\$50",
      "image": "assets/images/six.png",
    },
  ];

  final List<Map<String, dynamic>> completedOrders = [
    {
      "title": "Shoes",
      "brand": "Nike",
      "price": "\$90",
      "image": "assets/images/two.jpg",
    },
    {
      "title": "Backpack",
      "brand": "Adidas",
      "price": "\$70",
      "image": "assets/images/one.jpg",
    },
  ];

  final List<Map<String, dynamic>> cancelledOrders = [
    {
      "title": "Phone Case",
      "brand": "Samsung",
      "price": "\$20",
      "image": "assets/images/three.jpg",
    },
    {
      "title": "Sunglasses",
      "brand": "Ray-Ban",
      "price": "\$110",
      "image": "assets/images/images.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> currentOrders;
    String status = "";

    if (selectedIndex == 0) {
      currentOrders = activeOrders;
      status = "active";
    } else if (selectedIndex == 1) {
      currentOrders = completedOrders;
      status = "completed";
    } else {
      currentOrders = cancelledOrders;
      status = "cancelled";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFF6F6F6),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Orders",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab("Active", 0),
                  _buildTab("Completed", 1),
                  _buildTab("Cancel", 2),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: currentOrders.length,
                itemBuilder: (context, index) {
                  final item = currentOrders[index];
                  return OrderCard(
                    title: item["title"],
                    brand: item["brand"],
                    price: item["price"],
                    imageUrl: item["image"],
                    status: status,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.deepPurple : Colors.black,
              decoration: isActive ? TextDecoration.underline : TextDecoration.none,
              decorationColor: Colors.black,
              decorationThickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String title;
  final String brand;
  final String price;
  final String imageUrl;
  final String status;

  const OrderCard({
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  brand,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          if (status == "active")
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tracking your order...")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C5EFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: Text(
                "Track Order",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            )
          else if (status == "completed")
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Delivered",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[800]),
              ),
            )
          else if (status == "cancelled")
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Cancelled",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.red[800]),
                ),
              ),
        ],
      ),
    );
  }
}
