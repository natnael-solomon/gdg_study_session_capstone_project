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

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
              child:
Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

                  Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 32,
                              backgroundImage: 
                                   AssetImage('assets/images/person.jpg') as ImageProvider,
                            ),
                            title: Text(user.name.firstname),
                            subtitle: Text(user.email),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {},
                          ),
                        ),
                      ),
            SizedBox(height: 20),
            Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            buildSettingTile(
              Icons.notifications,
              'Notification',
              tileColor: Colors.grey[100],
            ),
            buildSettingTile(
              Icons.language,
              'Language',
              trailingText: 'English',
              tileColor: Colors.grey.shade100,
            ),
            buildSettingTile(
              Icons.privacy_tip,
              'Privacy',
              tileColor: Colors.grey.shade100,
            ),
            buildSettingTile(
              Icons.headset_mic,
              'Help Center',
              tileColor: Colors.grey.shade100,
            ),
            buildSettingTile(
              Icons.info,
              'About us',
              tileColor: Colors.grey.shade100,
            ),
          ],
        ),
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
          selectedItemColor: Colors.blue, // Customize the selected item color
          unselectedItemColor:
              Colors.grey[600], // Customize the unselected item color
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
  Widget buildSettingTile(
    IconData icon,
    String title, {
    String? trailingText,
    Color? tileColor,
  }) {
    return Card(
      color: tileColor ?? Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(trailingText),
              ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {},
      ),
    );
  }
 
  

