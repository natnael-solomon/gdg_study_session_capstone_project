import 'package:capstone_landing_page_project/ProductPage.dart';
import 'package:capstone_landing_page_project/ProfilePage.dart';
import 'package:capstone_landing_page_project/ProductDetailScreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:capstone_landing_page_project/models/user.dart';
import 'package:capstone_landing_page_project/models/products.dart';
import 'package:capstone_landing_page_project/UserDashboard.dart';
import 'package:capstone_landing_page_project/SettingPage.dart';
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int userId = 1;
  late Future<User> futureUser;
  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data! as User;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/images/person.jpg"),
                        onBackgroundImageError: (exception, stackTrace) {
                          print("Error loading network image: $exception");
                        },
                        foregroundImage: const AssetImage(
                          'assets/pro.png',
                        ), // Fallback image from assets
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Colors
                                  .grey[100], // Customize the camera icon background color
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color:
                              Colors.black87, // Customize the camera icon color
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${user.name.firstname} ${user.name.lastname}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Customize the name color
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${user.email}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500], // Customize the email color
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildProfileTile(
                    icon: Icons.person_outline,
                    title: 'Profile',
                    iconColor: Colors.black87, // Customize the icon color
                    textColor: Colors.black87, // Customize the text color
                    tileColor: Colors.white, // Customize the tile color
                    arrowColor: Colors.black54, // Customize the arrow color
                    onTap: () {
                      print('Profile Tapped');
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.settings_outlined,
                    title: 'Setting',
                    iconColor: Colors.black87,
                    textColor: Colors.black87,
                    tileColor: Colors.white,
                    arrowColor: Colors.black54,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingPage(),
                        ),
                      );
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.email_outlined,
                    title: 'Contact',
                    iconColor: Colors.black87,
                    textColor: Colors.black87,
                    tileColor: Colors.white,
                    arrowColor: Colors.black54,
                    onTap: () {
                      print('Contact Tapped');
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.share_outlined,
                    title: 'Share App',
                    iconColor: Colors.black87,
                    textColor: Colors.black87,
                    tileColor: Colors.white,
                    arrowColor: Colors.black54,
                    onTap: () {
                      print('Share App Tapped');
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.help_outline,
                    title: 'Help',
                    iconColor: Colors.black87,
                    textColor: Colors.black87,
                    tileColor: Colors.white,
                    arrowColor: Colors.black54,
                    onTap: () {
                      print('Help Tapped');
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        print('Sign Out Tapped');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Colors
                                .redAccent, // Customize the sign out text color
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text("errror");
          }
        },
      ),
      bottomNavigationBar: Container(
        color:
            Colors
                .white, // Customize the bottom navigation bar background color
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '',
            ),
          ],
          currentIndex: 3,
          selectedItemColor:
              Colors.blue, // Customize the selected item color
          unselectedItemColor:
              Colors.grey[600], // Customize the unselected item color
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserDashboard()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage()),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(productId: 1),
                  ),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
 Widget buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Color? tileColor,
    Color? arrowColor,
  }) {
    return Card(
      color: tileColor ?? Colors.white, // Use provided color or default to white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.black87), // Use provided color or default
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, color: textColor ?? Colors.black87), // Use provided color or default
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: arrowColor ?? Colors.black54, size: 18), // Use provided color or default
        onTap: onTap,
      ),
    );
  }

