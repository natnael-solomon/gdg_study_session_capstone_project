import 'package:capstone/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_manager.dart';
import 'filter_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  final UserManager _userManager = UserManager();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';

  String? _selectedCategory;
  String? _selectedGender;
  double _minPrice = 0;
  double _maxPrice = 1000;
  double _selectedMinPrice = 0;
  double _selectedMaxPrice = 1000;
  double _selectedMinRating = 0;
  double _selectedMaxRating = 5;
  int? _minReviewCount;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _userManager.addListener(_onUserDataChanged);
  }

  @override
  void dispose() {
    _userManager.removeListener(_onUserDataChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onUserDataChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadInitialData() async {
    try {
      final products = await _apiService.getProducts();
      if (!mounted) return;

      setState(() {
        _allProducts = List<Product>.from(products);
        _filteredProducts = List<Product>.from(products);
        _isLoading = false;

        final prices = _allProducts.map((p) => p.price);
        _minPrice = prices.reduce((a, b) => a < b ? a : b);
        _maxPrice = prices.reduce((a, b) => a > b ? a : b);
        _selectedMinPrice = _minPrice;
        _selectedMaxPrice = _maxPrice;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
      _applyFilters();
    });
  }

  bool get _areFiltersActive {
    return _selectedCategory != null ||
        _selectedGender != null ||
        _selectedMinPrice != _minPrice ||
        _selectedMaxPrice != _maxPrice ||
        _selectedMinRating != 0 ||
        _selectedMaxRating != 5 ||
        _minReviewCount != null;
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts =
          _allProducts.where((product) {
            final matchesQuery =
                _searchQuery.isEmpty ||
                product.title.toLowerCase().contains(_searchQuery);

            final matchesCategory =
                _selectedCategory == null ||
                product.category == _selectedCategory;

            final matchesGender =
                _selectedGender == null || product.category == _selectedGender;

            final matchesPrice =
                product.price >= _selectedMinPrice &&
                product.price <= _selectedMaxPrice;

            final matchesRating =
                product.rating.rate >= _selectedMinRating &&
                product.rating.rate <= _selectedMaxRating;

            final matchesReviewCount =
                _minReviewCount == null ||
                product.rating.count >= _minReviewCount!;

            return matchesQuery &&
                matchesCategory &&
                matchesGender &&
                matchesPrice &&
                matchesRating &&
                matchesReviewCount;
          }).toList();
    });
  }

  Future<void> _addToCart(Product product) async {
    await _userManager.addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${product.title} to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _toggleFavorite(int productId) async {
    await _userManager.toggleFavorite(productId);
  }

  Future<void> _openFilterScreen() async {
    final uniqueCategories =
        _allProducts
            .where(
              (product) =>
                  _selectedGender == null ||
                  product.category == _selectedGender,
            )
            .map((p) => p.category)
            .toSet()
            .toList();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => FilterScreen(
              categories: uniqueCategories,
              minPrice: _minPrice,
              maxPrice: _maxPrice,
              selectedMinPrice: _selectedMinPrice,
              selectedMaxPrice: _selectedMaxPrice,
              selectedMinRating: _selectedMinRating,
              selectedMaxRating: _selectedMaxRating,
              selectedCategory: _selectedCategory,
              minReviewCount: _minReviewCount,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedCategory = result['category'];
        _selectedGender = result['gender'];
        _selectedMinPrice = result['minPrice'];
        _selectedMaxPrice = result['maxPrice'];
        _selectedMinRating = result['minRating'];
        _selectedMaxRating = result['maxRating'];
        _minReviewCount = result['minReviewCount'];
        _applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Search',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${_userManager.cartItems.length}'),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CartScreen(cartItems: _userManager.cartItems),
                  ),
                ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Color(0xFF6055D8)),
                  onPressed: _openFilterScreen,
                ),
              ],
            ),
          ),
          if (_selectedGender != null || _selectedCategory != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_selectedGender != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            _selectedGender == "men's clothing"
                                ? "Men"
                                : "Women",
                          ),
                          onDeleted: () {
                            setState(() {
                              _selectedGender = null;
                              _selectedCategory = null;
                              _applyFilters();
                            });
                          },
                        ),
                      ),
                    if (_selectedCategory != null)
                      Chip(
                        label: Text(_selectedCategory!),
                        onDeleted: () {
                          setState(() {
                            _selectedCategory = null;
                            _applyFilters();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (_searchQuery.isEmpty && !_areFiltersActive)
                    ? Center(
                      child: Lottie.asset(
                        'assets/animations/search_idle3.json',
                        width: 300,
                        repeat: true,
                      ),
                    )
                    : _filteredProducts.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/animations/not_found.json',
                            width: 200,
                            repeat: false,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No results found",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          isFavorite: _userManager.favoriteIds.contains(
                            product.id,
                          ),
                          onFavoritePressed: () => _toggleFavorite(product.id),
                          onAddToCart: () => _addToCart(product),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported),
                        ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: onFavoritePressed,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6055D8),
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6055D8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: onAddToCart,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
