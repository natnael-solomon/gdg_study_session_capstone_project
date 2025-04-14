import 'package:flutter/material.dart';
import 'package:capstone/services/auth_service.dart';
import 'package:capstone/services/user_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> futureUserDetails;
  File? _profileImage;
  final UserManager _userManager = UserManager();
  int _orderCount = 0;
  int _cartItemsCount = 0;

  @override
  void initState() {
    super.initState();
    futureUserDetails = AuthService().getUserDetails();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    final cartCount = _userManager.cartItems.length;
    final orderCount = 5; 

    setState(() {
      _cartItemsCount = cartCount;
      _orderCount = orderCount;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // upd
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
        ],
      ),
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : user['photoUrl'] != null
                                  ? NetworkImage(user['photoUrl'])
                                  : const AssetImage("assets/images/person.jpg")
                                      as ImageProvider,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
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
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user['fullName'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user['email'] ?? 'No Email',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('Orders', _orderCount.toString()),
                      _buildStatCard('Cart', _cartItemsCount.toString()),
                      _buildStatCard('Points', '125'), 
                    ],
                  ),
                  const SizedBox(height: 24),

                  buildProfileTile(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.history,
                    title: 'Order History',
                    onTap: () {
                      Navigator.pushNamed(context, '/order-history');
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.favorite_border,
                    title: 'Wishlist',
                    onTap: () {
                      Navigator.pushNamed(context, '/wishlist');
                    },
                  ),
                  buildProfileTile(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await AuthService().signOut();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black54,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
