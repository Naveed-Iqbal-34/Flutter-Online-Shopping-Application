import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:database_in_flutter/ui_helper/ui_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'order_success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int get userId {
    return context.read<AuthProvider>().user!['id'];
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.user!['id'];

      context.read<CartProvider>().loadCart(userId);
    });
  }

  // ===========================================
  // PLACE ORDER
  // ===========================================

  void _placeOrder() {
    final provider = context.read<CartProvider>();
    final cartItems = provider.cartItems;

    if (cartItems.isEmpty) return;

    int itemCount = 0;
    double totalAmount = 0;

    for (final item in cartItems) {
      final int quantity = (item['quantity'] as num).toInt();
      final double price = (item['price'] as num).toDouble();

      itemCount += quantity;
      totalAmount += price * quantity;
    }

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
  }

  // ===========================================
  // SUBTOTAL
  // ===========================================

  double get subtotal {
    final cartItems = context.read<CartProvider>().cartItems;

    double total = 0;

    for (final item in cartItems) {
      final double price = (item['price'] as num).toDouble();
      final int quantity = (item['quantity'] as num).toInt();

      total += price * quantity;
    }

    return total;
  }

  // ===========================================
  // SHIPPING
  // ===========================================

  double get shipping {
    final cartItems = context.read<CartProvider>().cartItems;

    return cartItems.isEmpty ? 0 : 200;
  }

  // ===========================================
  // FINAL TOTAL
  // ===========================================

  double get total {
    return subtotal + shipping;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.cartItems;

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

          body: cartProvider.isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
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
      },
    );
  }

  // ===========================================
  // CART ITEM
  // ===========================================

  Widget _cartItem(int index) {
    final cartItems = context.read<CartProvider>().cartItems;
    final item = cartItems[index];

    final double price = (item['price'] as num).toDouble();
    final int quantity = (item['quantity'] as num).toInt();

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

                Text(
                  'Rs. ${price.toStringAsFixed(0)}',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorsUsed.electricBlue,
                  ),
                ),

                const Spacer(),

                // =================================
                // QUANTITY SELECTOR
                // =================================

                Container(
                  height: 34,
                  width: 112,

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,

                    children: [
                      // Minus

                      InkWell(
                        onTap: () {
                          _decreaseQuantity(index);
                        },

                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                          ),

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
                        '$quantity',

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
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                          ),

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

            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 32,
            ),
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
      padding: const EdgeInsets.fromLTRB(
        24,
        12,
        24,
        15,
      ),

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
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

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
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

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
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

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
              onPressed: _placeOrder,

              style: ElevatedButton.styleFrom(
                backgroundColor:
                ColorsUsed.electricBlue,

                foregroundColor: Colors.white,

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),

              child: const Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [
                  Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  // ===========================================
  // INCREASE QUANTITY
  // ===========================================

  Future<void> _increaseQuantity(int index) async {
    final provider = context.read<CartProvider>();
    final item = provider.cartItems[index];

    final int currentQuantity =
    (item['quantity'] as num).toInt();

    await provider.increaseQuantity(
      userId,
      item['cartId'],
      currentQuantity,
    );
  }

  // ===========================================
  // DECREASE QUANTITY
  // ===========================================

  Future<void> _decreaseQuantity(int index) async {
    final provider = context.read<CartProvider>();
    final item = provider.cartItems[index];

    final int currentQuantity =
    (item['quantity'] as num).toInt();

    await provider.decreaseQuantity(
      userId,
      item['cartId'],
      currentQuantity,
    );
  }

  // ===========================================
  // REMOVE ITEM
  // ===========================================

  Future<void> _removeItem(int index) async {
    final provider = context.read<CartProvider>();
    final item = provider.cartItems[index];

    await provider.deleteItem(
      userId,
      item['cartId'],
    );
  }

  // ===========================================
  // CLEAR CART
  // ===========================================

  Future<void> _clearCart() async {
    final provider = context.read<CartProvider>();

    if (provider.cartItems.isEmpty) {
      return;
    }

    await provider.clearCart(userId);
  }

  // ===========================================
  // EMPTY CART
  // ===========================================

  Widget _emptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),

          SizedBox(height: 15),

          Text(
            'Your cart is empty',

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}