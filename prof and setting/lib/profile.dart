import 'package:flutter/material.dart';
import 'setting.dart'; // Import the settings_page.dart file

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Customize the background color here
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold background transparent
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

         
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: const NetworkImage(
                      'https://via.placeholder.com/120', // Replace with your actual network image URL
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      print("Error loading network image: $exception");
                    },
                    foregroundImage: const AssetImage('assets/pro.png'), // Fallback image from assets
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100], // Customize the camera icon background color
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.black87, // Customize the camera icon color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Mark Adam',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Customize the name color
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sunny_Koelpin45@hotmail.com',
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
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
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
                    foregroundColor: Colors.redAccent, // Customize the sign out text color
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white, // Customize the bottom navigation bar background color
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
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
            unselectedItemColor: Colors.grey[600], // Customize the unselected item color
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
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
}