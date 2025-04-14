import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final List<String> categories;
  final double minPrice;
  final double maxPrice;
  final double selectedMinPrice;
  final double selectedMaxPrice;
  final double selectedMinRating;
  final double selectedMaxRating;
  final String? selectedCategory;
  final int? minReviewCount;

  const FilterScreen({
    super.key,
    required this.categories,
    required this.minPrice,
    required this.maxPrice,
    required this.selectedMinPrice,
    required this.selectedMaxPrice,
    required this.selectedMinRating,
    required this.selectedMaxRating,
    required this.selectedCategory,
    required this.minReviewCount,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late double _selectedMinPrice;
  late double _selectedMaxPrice;
  late double _selectedMinRating;
  late double _selectedMaxRating;
  String? _selectedCategory;
  int? _minReviewCount;

  List<bool> _genderSelection = [true, false, false];
  List<String> genders = ['All', "Men's", "Women's"];

  List<bool> _categorySelection = [];

  @override
  void initState() {
    super.initState();
    _selectedMinPrice = widget.selectedMinPrice;
    _selectedMaxPrice = widget.selectedMaxPrice;
    _selectedMinRating = widget.selectedMinRating;
    _selectedMaxRating = widget.selectedMaxRating;
    _selectedCategory = widget.selectedCategory;
    _minReviewCount = widget.minReviewCount;

    _categorySelection = List<bool>.filled(widget.categories.length, false);
    if (_selectedCategory != null) {
      final index = widget.categories.indexOf(_selectedCategory!);
      if (index != -1) {
        _categorySelection[index] = true;
      }
    }
  }

  void _applyFilters() {
    final selectedIndex = _categorySelection.indexWhere((selected) => selected);
    final category =
        selectedIndex != -1 ? widget.categories[selectedIndex] : null;

    Navigator.pop(context, {
      'category': category,
      'minPrice': _selectedMinPrice,
      'maxPrice': _selectedMaxPrice,
      'minRating': _selectedMinRating,
      'maxRating': _selectedMaxRating,
      'minReviewCount': _minReviewCount,
      'gender':
          _genderSelection[0]
              ? null
              : _genderSelection[1]
              ? "men's clothing"
              : "women's clothing",
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedMinPrice = widget.minPrice;
      _selectedMaxPrice = widget.maxPrice;
      _selectedMinRating = 0;
      _selectedMaxRating = 5;
      _selectedCategory = null;
      _minReviewCount = null;
      _genderSelection = [true, false, false];
      _categorySelection = List<bool>.filled(widget.categories.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(genders.length, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(110, 60),
                        backgroundColor:
                            _genderSelection[index]
                                ? const Color(0xFF6055D8)
                                : Colors.grey[200],
                        foregroundColor:
                            _genderSelection[index] ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          for (int i = 0; i < _genderSelection.length; i++) {
                            _genderSelection[i] = i == index;
                          }
                        });
                      },
                      child: Text(genders[index]),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
        
            const Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.categories.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(110, 60),
                        backgroundColor:
                            _categorySelection[index]
                                ? const Color(0xFF6055D8)
                                : Colors.grey[200],
                        foregroundColor:
                            _categorySelection[index]
                                ? Colors.white
                                : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          for (int i = 0; i < _categorySelection.length; i++) {
                            _categorySelection[i] = i == index;
                          }
                        });
                      },
                      child: Text(widget.categories[index]),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 30),
        
            const Text(
              "Price Range",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              values: RangeValues(_selectedMinPrice, _selectedMaxPrice),
              min: widget.minPrice,
              max: widget.maxPrice,
              divisions: 100,
              labels: RangeLabels(
                '\$${_selectedMinPrice.toStringAsFixed(0)}',
                '\$${_selectedMaxPrice.toStringAsFixed(0)}',
              ),
              onChanged: (range) {
                setState(() {
                  _selectedMinPrice = range.start;
                  _selectedMaxPrice = range.end;
                });
              },
            ),
            const SizedBox(height: 16),
        
            const Text(
              "Rating Range",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              values: RangeValues(_selectedMinRating, _selectedMaxRating),
              min: 0,
              max: 5,
              divisions: 5,
              labels: RangeLabels(
                '${_selectedMinRating.toStringAsFixed(1)}★',
                '${_selectedMaxRating.toStringAsFixed(1)}★',
              ),
              onChanged: (range) {
                setState(() {
                  _selectedMinRating = range.start;
                  _selectedMaxRating = range.end;
                });
              },
            ),
            const SizedBox(height: 16),
        
            const Text(
              "Min Review Count",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "e.g., 50",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _minReviewCount = int.tryParse(val),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6055D8),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _applyFilters,
              child: const Text(
                "APPLY FILTERS",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
