import 'package:flutter/material.dart';
import 'services/api_service.dart';  // Ensure this file contains the ApiService
import 'users/user_model.dart';   // Ensure this file contains the UserModel
import 'profile.dart';   // Ensure this file contains the UserModel

void main() {
  runApp(SettingsApp());
}

class SettingsApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SettingsPage(), debugShowCheckedModeBanner: false);
  }
}

class SettingsPage extends StatefulWidget {
   const SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserModel? user;
  bool isLoading = true; // To handle loading state

  @override
  void initState() {
    super.initState();
    // Fetch user data from API
    ApiService.fetchUser().then((data) {
      setState(() {
        user = data;
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      // Handle error if API call fails
      print("Error fetching user data: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
             Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator()) // Loading indicator
                : user == null
                    ? Center(child: Text("Failed to load user data")) // Show error if user data is null
                    : Card(
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
                              backgroundImage: user!.imageUrl != null
                                  ? NetworkImage(user!.imageUrl!)
                                  : AssetImage('assets/pro.png') as ImageProvider,
                            ),
                            title: Text(user!.name),
                            subtitle: Text(user!.email),
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
}
