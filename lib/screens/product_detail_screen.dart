import 'package:flutter/material.dart';
import 'package:database_in_flutter/ui_helper/ui_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {

    // Get product data from database
    final String name =
        widget.product['name'] ?? 'Product';

    final double price =
    (widget.product['price'] ?? 0).toDouble();

    final double rating =
    (widget.product['rating'] ?? 0).toDouble();

    final String category =
        widget.product['category'] ?? 'Category';

    final String imagePath =
        widget.product['imagePath'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  const Color(0xFFEFEFEF),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_rounded)),
        actions: [

          // FAVORITE BUTTON
          IconButton(
            onPressed: () {

              setState(() {
                isFavorite =
                !isFavorite;
              });

            },

            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,

              size: 30,

              color: isFavorite
                  ? Colors.red
                  : Colors.black,
            ),
          ),

          // SHARE BUTTON
          IconButton(
            onPressed: () {
              // Share product
            },

            icon: const Icon(
              Icons.share_outlined,
              size: 28,
              color: Colors.black,
            ),
          ),

        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              // =====================================
              // MAIN CONTENT
              // =====================================
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
          
                  // =================================
                  // PRODUCT IMAGE
                  // =================================
          
                  Stack(
                    children: [
          
                      Container(
                        height: 350,
                        width: double.infinity,
                        color: const Color(0xFFEFEFEF),

                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
          
                  // =================================
                  // PRODUCT INFORMATION
                  // =================================
          
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 19,
                        vertical: 10,
                      ),
          
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
          
                        children: [
          
                          // Product name
                          Text(
                            name,
          
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
          
                          const SizedBox(height: 7),
          
                          // =================================
                          // RATING
                          // =================================
          
                          Row(
                            children: [
          
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 20,
                              ),
          
                              const SizedBox(width: 4),
          
                              Text(
                                rating.toString(),
          
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
          
                              const SizedBox(width: 8),
          
                              Text(
                                '(124 reviews)',
          
                                style: TextStyle(
                                  color:
                                  Colors.grey.shade400,
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
          
                          const SizedBox(height: 7),
          
                          // =================================
                          // PRICE + DISCOUNT
                          // =================================
          
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
          
                            children: [
          
                              Text(
                                'Rs. ${price.toStringAsFixed(0)}',
          
                                style: TextStyle(
                                  color: ColorsUsed.electricBlue,
                                  fontSize: 32,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
          
                              const SizedBox(width: 20),
          
                              Text(
                                'Rs. ${(price * 1.25).toStringAsFixed(0)}',
          
                                style: TextStyle(
                                  color:
                                  Colors.grey.shade400,
                                  fontSize: 15,
                                  decoration:
                                  TextDecoration
                                      .lineThrough,
                                ),
                              ),
          
                              const Spacer(),
          
                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 11,
                                  vertical: 9,
                                ),
          
                                decoration:
                                BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                  BorderRadius
                                      .circular(15),
                                ),
          
                                child: const Text(
                                  '20% OFF',
          
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
          
                          const SizedBox(height: 12),
          
                          // =================================
                          // CATEGORY
                          // =================================
          
                          Row(
                            children: [
          
                              const Text(
                                'Category: ',
          
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
          
                              Text(
                                category,
          
                                style: TextStyle(
                                  color: ColorsUsed.electricBlue,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
          
                          const SizedBox(height: 12),
          
                          // =================================
                          // PRODUCT DETAILS
                          // =================================
          
                          const Text(
                            'Product Details',
          
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
          
                          const SizedBox(height: 5),
          
                          Text(
                            _getDescription(category),
          
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
          
                          const SizedBox(height: 10),
          
                          // =================================
                          // FEATURES
                          // =================================
          
                          _featureItem(
                            Icons.check_circle_outline,
                            'High-quality product',
                          ),
          
                          _featureItem(
                            Icons.local_shipping_outlined,
                            'Fast and reliable delivery',
                          ),
          
                          _featureItem(
                            Icons.verified_outlined,
                            'ShopEasy verified product',
                          ),
          
                          const SizedBox(height: 7),
          
                          // =================================
                          // QUANTITY
                          // =================================
          
                          Container(
                            height: 40,
                            width: 155,
          
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                Colors.grey.shade400,
                              ),
          
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
          
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceAround,
          
                              children: [
          
                                // Minus
                                IconButton(
                                  padding: EdgeInsets.zero,
          
                                  onPressed: () {
          
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
          
                                  },
          
                                  icon: const Icon(
                                    Icons.remove,
                                    size: 20,
                                  ),
                                ),
          
                                // Quantity
                                Text(
                                  '$quantity',
          
                                  style:
                                  const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
          
                                // Plus
                                IconButton(
                                  padding: EdgeInsets.zero,
          
                                  onPressed: () {
          
                                    setState(() {
                                      quantity++;
                                    });
          
                                  },
          
                                  icon: const Icon(
                                    Icons.add,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
          
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          
              // =====================================
              // ADD TO CART BUTTON
              // =====================================
          
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  19,
                  5,
                  19,
                  15,
                ),
          
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
          
                  child: ElevatedButton(
                    onPressed: () async {
          
                      final productId = widget.product['id'];

                      final authProvider = context.read<AuthProvider>();
                      final userId = authProvider.user!['id'];

                      await context.read<CartProvider>().addToCart(
                        userId,
                        productId,
                        quantity,
                      );
          
                      if (!context.mounted) return;
          
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Product added to cart',
                          ),
                        ),
                      );
                    },
          
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      ColorsUsed.electricBlue,
          
                      foregroundColor: Colors.white,
          
                      elevation: 0,
          
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
          
                    child: const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
          
                      children: [
          
                        Text(
                          'Add to Cart',
          
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
          
                        SizedBox(width: 15),
          
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================
  // FEATURE ITEM
  // =====================================

  Widget _featureItem(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
      ),

      child: Row(
        children: [

          SizedBox(
            width: 45,

            child: Icon(
              icon,
              color: ColorsUsed.electricBlue,
              size: 25,
            ),
          ),

          Text(
            text,

            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // DESCRIPTION
  // =====================================

  String _getDescription(String category) {

    switch (category) {

      case 'Electronics':
        return 'High-quality electronic product designed '
            'for everyday use. Enjoy reliable performance, '
            'modern features, and a comfortable user '
            'experience with this product from ShopEasy.';

      case 'Fashion':
        return 'Stylish and comfortable fashion product '
            'made for everyday use. Designed with quality '
            'materials and a modern look for your personal style.';

      case 'Home & Living':
        return 'A practical and stylish product for your '
            'home. Designed to provide convenience, '
            'quality, and comfort for everyday living.';

      case 'Beauty':
        return 'A quality beauty product designed for '
            'everyday use. Enjoy a simple and convenient '
            'experience with this ShopEasy product.';

      default:
        return 'A high-quality product from ShopEasy. '
            'Designed to provide excellent value, quality, '
            'and convenience for everyday use.';
    }
  }
}