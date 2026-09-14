import 'package:database_in_flutter/screens/product_list_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Electronics',
      'icon': Icons.headphones,
      'color': Color(0xFF263F5E),
    },
    {
      'name': 'Fashion',
      'icon': Icons.checkroom,
      'color': Color(0xFFE53935),
    },
    {
      'name': 'Home & Living',
      'icon': Icons.home_outlined,
      'color': Color(0xFF2196F3),
    },
    {
      'name': 'Beauty',
      'icon': Icons.local_drink_outlined,
      'color': Color(0xFFE83EAA),
    },
    {
      'name': 'Sports',
      'icon': Icons.sports_soccer,
      'color': Color(0xFF1769E0),
    },
    {
      'name': 'Toys',
      'icon': Icons.toys_outlined,
      'color': Color(0xFFFF7A00),
    },
    {
      'name': 'Books',
      'icon': Icons.menu_book_outlined,
      'color': Color(0xFF03A9F4),
    },
    {
      'name': 'Groceries',
      'icon': Icons.shopping_cart_outlined,
      'color': Color(0xFF00A86B),
    },
  ];

  List<Map<String, dynamic>> filteredCategories = [];

  @override
  void initState() {
    super.initState();

    filteredCategories = categories;

    _searchController.addListener(_searchCategories);
  }

  void _searchCategories() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredCategories = categories.where((category) {
        return category['name']
            .toString()
            .toLowerCase()
            .contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchCategories);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // =========================================
      // APP BAR
      // =========================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        centerTitle: true,

        // Empty space keeps title centered.
        leading: const SizedBox(),

        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================================
      // BODY
      // =========================================

      body: SafeArea(
        child: Column(
          children: [

            // =====================================
            // SEARCH BAR
            // =====================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                5,
                20,
                15,
              ),

              child: TextField(
                controller: _searchController,

                decoration: InputDecoration(
                  hintText: 'Search categories...',

                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),

                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding:
                  const EdgeInsets.symmetric(
                    vertical: 12,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),

                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),

                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),

                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            // =====================================
            // CATEGORY GRID
            // =====================================

            Expanded(
              child: filteredCategories.isEmpty
                  ? const Center(
                child: Text(
                  'No category found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  20,
                ),

                itemCount:
                filteredCategories.length,

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,

                  childAspectRatio: 1.25,
                ),

                itemBuilder: (context, index) {
                  final category =
                  filteredCategories[index];

                  return _categoryCard(
                    category,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================
  // CATEGORY CARD
  // ===========================================

  Widget _categoryCard(
      Map<String, dynamic> category) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductListScreen(
                category: category['name'],
              ),
            ),
          );
        },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),

          borderRadius:
          BorderRadius.circular(14),

          border: Border.all(
            color: Colors.grey.shade200,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            // =================================
            // ICON
            // =================================

            Icon(
              category['icon'],
              size: 43,
              color: category['color'],
            ),

            const SizedBox(height: 12),

            // =================================
            // CATEGORY NAME
            // =================================

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 5,
              ),

              child: Text(
                category['name'],

                textAlign: TextAlign.center,

                maxLines: 1,

                overflow:
                TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}