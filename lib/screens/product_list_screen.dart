import 'package:flutter/material.dart';

import '../database_helper/database_helper.dart';

class ProductListScreen extends StatefulWidget {
  final String category;

  const ProductListScreen({super.key, required this.category});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int selectedFilter = 0;

  final List<String> filters = ['All'];

  List<Map<String, dynamic>> products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final result = await DatabaseHelper.instance.getProductsByCategory(
      widget.category,
    );

    if (!mounted) return;

    setState(() {
      products = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedFilter == 0
        ? products
        : products.where((product) {
            return product['category'] == filters[selectedFilter];
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      // =========================================
      // APP BAR
      // =========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),

        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              // Search action
            },

            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),

      // =========================================
      // BODY
      // =========================================
      body: Column(
        children: [
          // =====================================
          // FILTER BUTTONS
          // =====================================
          SizedBox(
            height: 48,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(horizontal: 15),

              itemCount: filters.length,

              itemBuilder: (context, index) {
                final selected = selectedFilter == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),

                  child: ChoiceChip(
                    label: Text(filters[index]),

                    selected: selected,

                    onSelected: (_) {
                      setState(() {
                        selectedFilter = index;
                      });
                    },

                    selectedColor: const Color(0xFF1976D2),

                    backgroundColor: const Color(0xFFF5F5F5),

                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,

                      fontSize: 11,

                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),

                    side: BorderSide.none,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 5),

          // =====================================
          // PRODUCT LIST
          // =====================================
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),

                    itemCount: filteredProducts.length,

                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return _productCard(product);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ===========================================
  // PRODUCT CARD
  // ===========================================

  Widget _productCard(Map<String, dynamic> product) {
    return Container(
      height: 82,

      margin: const EdgeInsets.only(bottom: 5),

      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),

      child: Row(
        children: [
          // =====================================
          // PRODUCT IMAGE
          // =====================================
          Container(
            width: 60,
            height: 68,

            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),

              borderRadius: BorderRadius.circular(8),
            ),

            padding: const EdgeInsets.all(6),

            child: Image.asset(
              product['imagePath'] ?? '',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 35,
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // =====================================
          // PRODUCT DETAILS
          // =====================================
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  product['name'],

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Rs. ${product['price']}',

                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.amber),

                    const SizedBox(width: 3),

                    Text(
                      '${product['rating']}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =====================================
          // ADD TO CART BUTTON
          // =====================================
          IconButton(
            onPressed: () async {
              final productId = product['id'];

              await DatabaseHelper.instance.addToCart(
                1, // userId
                productId,
                1, // quantity
              );

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product['name']} added to cart'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },

            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF1976D2),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
