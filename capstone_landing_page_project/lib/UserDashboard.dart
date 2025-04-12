import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capstone_landing_page_project/models/user.dart';
import 'package:capstone_landing_page_project/models/products.dart';

Future<User> fetchUser(int userId) async {
  final url = Uri.parse("https://fakestoreapi.com/users/$userId");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return User.fromJson(data);
  } else {
    throw Exception("Failed to load user");
  }
}

Future<List<Products>> fetchProducts() async {
  final url = Uri.parse("https://fakestoreapi.com/products/");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final List<dynamic> json_data = jsonDecode(response.body);
    return json_data.map((item) => Products.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load user");
  }
}

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late Future<List<dynamic>> combinedFuture;
  final int userId = 1;
  @override
  void initState() {
    super.initState();
    combinedFuture = Future.wait([fetchUser(userId), fetchProducts()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: FutureBuilder<List<dynamic>>(
        future: combinedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data![0] as User;
            final products = snapshot.data![1] as List<Products>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children:[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/person.jpg",
                                  width: 50,
                                  height: 50,
                    
                                ),
                              )
                            ]
                          ),
                          IconButton(
                            icon: Icon(Icons.notification_add),
                            onPressed: () {
                              // Handle logout action
                            },
                          ),
                        ],
                      ),
                      Text(
                        "User ID: ${user.id}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Name: ${user.name.firstname} ${user.name.lastname}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Email: ${user.email}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Username: ${user.username}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Phone: ${user.phone}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Address: ${user.address.street}, ${user.address.city}, ${user.address.zipcode}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Address Number: ${user.address.number}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Address Geolocation: ${user.address.geolocation.lat}, ${user.address.geolocation.long}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        width: 120,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
