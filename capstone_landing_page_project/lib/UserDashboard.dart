import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:capstone_landing_page_project/models/user.dart';
import 'package:capstone_landing_page_project/models/products.dart';
class MyCarouselWidget extends StatelessWidget{
  final List<String> imageList = [
    "assets/images/1.jpg",
    "assets/images/2.jpg",
    "assets/images/3.jpeg",
    "assets/images/4.jpeg",
  ];
  @override
  Widget build(BuildContext context){
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,

      ),
      items: imageList.map((imagePath){
        return Builder(
          builder: (BuildContext context){
            return ClipRRect(
              borderRadius:BorderRadius.circular(5),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          }
        );
      }).toList(),
    );
  }
}
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
            return SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children:[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  "assets/images/person.jpg",
                                  width: 50,
                                  height: 50, // Make height equal to width
                                  fit: BoxFit.cover, // Ensure the image fits properly
                                ),
                              ),
                              SizedBox(width: 10), 
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    "${user.name.firstname} ${user.name.lastname}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ]
                          ),
                          IconButton(
                            iconSize: 30,
                            icon: Icon(Icons.notification_add),
                            onPressed: () {
                              // Handle logout action
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Stack(
                        children: [
                            Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(255, 227, 227, 227),
                                ),
                                onChanged: (value) {
                                // Handle search input
                                },
                              ),
                              ),

                            ],
                            )
                        ],
                      
                      ),
                      SizedBox(height: 20),
                      MyCarouselWidget(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                       
                          Text("Featured",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("See all",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ]

                      ),
 SizedBox(height: 10),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(
                              "\$${product.price}",
                              style: TextStyle(
                                fontSize: 16,
                                color:Colors.lightBlue,
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
                SizedBox(height: 20),
                Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                       
                          Text("Most Popular",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("See all",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ]

                      ),
 SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final product = products[index+5];
                      return Container(
                        width: 120,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(
                              "\$${product.price}",
                              style: TextStyle(
                                fontSize: 16,
                                color:Colors.lightBlue,
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
                  ),
 
                ),
               
              ],

              ),

            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
      bottomNavigationBar:BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),
        ],
      )
    );
  }
}
