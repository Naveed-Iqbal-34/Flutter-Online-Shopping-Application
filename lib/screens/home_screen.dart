import 'package:database_in_flutter/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:database_in_flutter/ui_helper/ui_helper.dart';
import '../providers/product_provider.dart';
// =========================================================================
// 2. MAIN HOME VIEW INTERFACE
// =========================================================================
class ShopEasyHomeTab extends StatefulWidget {
  const ShopEasyHomeTab({super.key});

  @override
  State<ShopEasyHomeTab> createState() => _ShopEasyHomeTabState();
}

class _ShopEasyHomeTabState extends State<ShopEasyHomeTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductProvider>().loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper builder widget to construct clean category icon button circles
  Widget _buildCategoryItem(String label, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(iconData, color: Colors.black87, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      // Clean layout base backing color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟦 A. DYNAMIC BLUE BRAND HEADER WITH SEARCH INPUT BAR
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            decoration: BoxDecoration(color: ColorsUsed.electricBlue),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    const Text(
                      'ShopEasy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black54,
                          builder: (context) {
                            return Center(
                              child: Container(
                                margin: const EdgeInsets.all(30),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'This is my overlay',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Interactive Search Input: Triggers live real-time filtering updates
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<ProductProvider>().searchProducts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for products...',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black87,
                      size: 24,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    // B. PROMO BANNER GRAPHIC SECTION
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 170,
                          width: double.infinity,
                          padding: const EdgeInsets.all(0),
                          color: const Color(0xFF437FFF).withAlpha(30),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/back.png',
                                  fit: BoxFit
                                      .cover, // Stretches beautifully to fill the entire depth of the card
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: const Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900
                                        ),
                                        // 1. Baseline style for everything
                                        children: [
                                          TextSpan(text: 'Big Sale\nUp to '),
                                          TextSpan(
                                            text: '20%',
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF043294),
                                            ), // 2. Custom Bold & Blue!
                                          ),
                                          TextSpan(
                                            text: ' off',
                                          ),
                                          TextSpan(
                                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                            text: '\nShop more, Save more',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 🏷️ C. CATEGORIES RIBBON SECTION
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See All >',
                              style: TextStyle(
                                color: Color(0xFF437FFF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          _buildCategoryItem(
                            'Electronics',
                            Icons.phone_android,
                          ),
                          _buildCategoryItem(
                            'Home & Living',
                            Icons.home_outlined,
                          ),
                          _buildCategoryItem('Fashion', Icons.checkroom),
                          _buildCategoryItem('Beauty', Icons.brush_outlined),
                        ],
                      ),
                    ),

                    // 🛒 D. FEATURED PRODUCTS DATA-DRIVEN GRID VIEW
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Featured Products',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See All >',
                              style: TextStyle(
                                color: Color(0xFF437FFF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    provider.products.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text(
                                'No active product data records matched query.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.82,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: provider.products.length,
                            itemBuilder: (context, index) {
                              final item = provider.products[index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailScreen(
                                          product: item,
                                        ),
                                      ),
                                    );
                                  },

                                  child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Database Image Render Core
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            item['imagePath'] ??
                                                'assets/images/headphones.png',
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Content Metadata Summary Frame
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] ?? 'Product Item',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Rs. ${item['price'].toString().replaceAll('.0', '')}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${item['rating'] ?? "4.5"}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              );
                            },
                          ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
