import 'package:flutter/material.dart';
import 'package:database_in_flutter/ui_helper/ui_helper.dart';

import '../database_helper/database_helper.dart';
import 'order_success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  bool isLoading = true;

  final int userId = 1;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void _placeOrder() {
    if (cartItems.isEmpty) return;

    int itemCount = 0;
    double totalAmount = 0;

    for (final item in cartItems) {
      final int quantity = item['quantity'] as int;
      final double price = (item['price'] as num).toDouble();

      itemCount += quantity;
      totalAmount += price * quantity;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          orderId: '#${DateTime.now().millisecondsSinceEpoch}',
          itemCount: itemCount,
          totalAmount: totalAmount,
          estimatedDelivery: '2026.9.18',
        ),
      ),
    );
  }

  Future<void> loadCart() async {
    try {
      final items = await DatabaseHelper.instance.getCartItems(1);

      if (!mounted) return;

      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      print('ERROR LOADING CART: $e');

      if (!mounted) return;

      setState(() {
        cartItems = [];
        isLoading = false;
      });
    }
  }

  // Calculate subtotal
  double get subtotal {
    double total = 0;

    for (var item in cartItems) {
      total += item['price'] * item['quantity'];
    }

    return total;
  }

  // Shipping
  double get shipping {
    return cartItems.isEmpty ? 0 : 200;
  }

  // Final total
  double get total {
    return subtotal + shipping;
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
        elevation: 2,

        centerTitle: true,

        leading: const SizedBox(),

        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              _clearCart();
            },

            icon: const Icon(
              Icons.delete_outline,
              color: Colors.black,
              size: 30,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // =========================================
      // BODY
      // =========================================
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? _emptyCart()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 23,
                            vertical: 10,
                          ),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            return _cartItem(index);
                          },
                        ),
                ),

                if (cartItems.isNotEmpty) _bottomSummary(),
              ],
            ),
    );
  }

  // ===========================================
  // CART ITEM
  // ===========================================

  Widget _cartItem(int index) {
    final item = cartItems[index];

    return Container(
      height: 112,

      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(17),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // =================================
          // PRODUCT IMAGE
          // =================================
          Container(
            width: 90,
            height: 90,

            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Padding(
              padding: const EdgeInsets.all(8),

              child: Image.asset(
                item['imagePath'],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 35,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 17),

          // =================================
          // PRODUCT INFORMATION
          // =================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 3),

                // Product name
                Text(
                  item['name'],

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 3),

                // Price
                Text(
                  'Rs. ${item['price'].toStringAsFixed(0)}',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorsUsed.electricBlue,
                  ),
                ),

                const Spacer(),

                // Quantity selector
                Container(
                  height: 34,
                  width: 112,

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      // Minus
                      InkWell(
                        onTap: () {
                          _decreaseQuantity(index);
                        },

                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7),

                          child: Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Quantity
                      Text(
                        '${item['quantity']}',

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Plus
                      InkWell(
                        onTap: () {
                          _increaseQuantity(index);
                        },

                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7),

                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // =================================
          // DELETE BUTTON
          // =================================
          const SizedBox(width: 10),

          IconButton(
            onPressed: () {
              _removeItem(index);
            },

            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 32),
          ),
        ],
      ),
    );
  }

  // ===========================================
  // BOTTOM SUMMARY
  // ===========================================

  Widget _bottomSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 15),

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: Column(
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                'Subtotal',

                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                'Rs. ${subtotal.toStringAsFixed(0)}',

                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                'Shipping',

                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                'Rs. ${shipping.toStringAsFixed(0)}',

                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Divider(),

          const SizedBox(height: 7),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                'Total',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              Text(
                'Rs. ${total.toStringAsFixed(0)}',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorsUsed.electricBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =====================================
          // CHECKOUT BUTTON
          // =====================================
          SizedBox(
            width: double.infinity,
            height: 52,

            child: ElevatedButton(
              onPressed: () {
                if (cartItems.isEmpty) return;

                // Calculate item count
                int itemCount = 0;

                // Calculate total price
                double totalAmount = 0;

                for (final item in cartItems) {
                  final int quantity = (item['quantity'] as num).toInt();
                  final double price = (item['price'] as num).toDouble();

                  itemCount += quantity;
                  totalAmount += price * quantity;
                }

                // Add shipping
                totalAmount += shipping;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderSuccessScreen(
                      orderId: '#${DateTime.now().millisecondsSinceEpoch}',
                      itemCount: itemCount,
                      totalAmount: totalAmount,
                      estimatedDelivery: '2026.9.18',
                    ),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsUsed.electricBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(width: 15),

                  Icon(Icons.arrow_forward_ios, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================
  // INCREASE QUANTITY
  // ===========================================

  Future<void> _increaseQuantity(int index) async {
    final item = cartItems[index];

    final newQuantity = item['quantity'] + 1;

    await DatabaseHelper.instance.updateCartQuantity(
      item['cartId'],
      newQuantity,
    );

    await loadCart();
  }

  // ===========================================
  // DECREASE QUANTITY
  // ===========================================

  Future<void> _decreaseQuantity(int index) async {
    final item = cartItems[index];

    final currentQuantity = item['quantity'];

    if (currentQuantity > 1) {
      await DatabaseHelper.instance.updateCartQuantity(
        item['cartId'],
        currentQuantity - 1,
      );

      await loadCart();
    }
  }

  // ===========================================
  // REMOVE ITEM
  // ===========================================

  Future<void> _removeItem(int index) async {
    final item = cartItems[index];

    final cartId = item['cartId'];

    await DatabaseHelper.instance.deleteCartItem(cartId);

    await loadCart();
  }

  // ===========================================
  // CLEAR CART
  // ===========================================

  Future<void> _clearCart() async {
    if (cartItems.isEmpty) {
      return;
    }

    await DatabaseHelper.instance.clearCart(userId);

    await loadCart();
  }

  // ===========================================
  // EMPTY CART
  // ===========================================

  Widget _emptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),

          SizedBox(height: 15),

          Text(
            'Your cart is empty',

            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
