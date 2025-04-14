import 'package:flutter/material.dart';
import 'package:capstone/services/auth_service.dart'; // Import the AuthService

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> futureUserDetails;

  @override
  void initState() {
    super.initState();
    futureUserDetails =
        AuthService().getUserDetails(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: futureUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
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
                        backgroundImage:
                            user['photoUrl'] != null
                                ? NetworkImage(user['photoUrl'])
                                : const AssetImage("assets/images/person.jpg")
                                    as ImageProvider,
                        onBackgroundImageError: (exception, stackTrace) {
                          print("Error loading image: $exception");
                        },
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
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${user['fullName']}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${user['email']}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  buildProfileTile(
                    icon: Icons.person_outline,
                    title: 'Profile',
                    iconColor: Colors.black87,
                    textColor: Colors.black87,
                    tileColor: Colors.white,
                    arrowColor: Colors.black54,
                    onTap: () {
                      print('Profile Tapped');
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    iconColor: Colors.black87,
                    textColor: Colors.black87,
                    tileColor: Colors.white,
                    arrowColor: Colors.black54,
                    onTap: () {
                      print('Settings Tapped');
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
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await AuthService().signOut();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
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
            return const Center(child: Text("No user data available"));
          }
        },
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
    color: tileColor ?? Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: arrowColor ?? Colors.black54,
        size: 18,
      ),
      onTap: onTap,
    ),
  );
}
