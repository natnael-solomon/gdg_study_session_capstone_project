import 'dart:async';
import 'package:capstone/products/product_list_screen.dart';
import 'package:capstone/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/product.dart';
import '../search/search_screen.dart';
import 'product_list.dart';
import 'banner_carousel.dart';
import 'section_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color accentColor = const Color(0xFF6C63FF);
  final ApiService _apiService = ApiService();
  List<Product> _featuredProducts = [];
  List<Product> _popularProducts = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _apiService.getProducts();
      if (mounted) {
        setState(() {
          _featuredProducts = products.sublist(0, 3);
          _popularProducts = products.sublist(3, 6);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load products: $e')));
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromARGB(255, 248, 247, 247),
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(),
            const SearchScreen(),
            const ProductListScreen(),
            const ProfilePage(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTopBar(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 20),
            BannerCarousel(accentColor: accentColor),
            const SizedBox(height: 20),
            SectionHeader(
              title: "Featured",
            ),
            _isLoading
                ? _buildLoadingIndicator()
                : ProductList(products: _featuredProducts),
            const SizedBox(height: 20),
            SectionHeader(
              title: "Most Popular",
            ),
            _isLoading
                ? _buildLoadingIndicator()
                : ProductList(products: _popularProducts),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final authService = AuthService();
    final currentUser = authService.currentUser;

    if (currentUser == null) {
      return const SizedBox();
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: authService.getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Text("Error loading user");
        }

        final userData = snapshot.data!;
        final fullName = userData['fullName'] ?? 'No Name';
        final photoUrl = userData['photoUrl'] ?? '';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : const AssetImage('assets/user.png')
                              as ImageProvider,
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello!",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      fullName,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.notifications_none, size: 28),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Search here",
        hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w200),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 160,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
