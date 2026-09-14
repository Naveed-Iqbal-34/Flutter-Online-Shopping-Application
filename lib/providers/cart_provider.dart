import 'package:flutter/foundation.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<Map<String, dynamic>> cartItems = [];

  bool isLoading = false;

  // Load cart
  Future<void> loadCart(int userId) async {
    isLoading = true;
    notifyListeners();

    try {
      cartItems = await _cartService.getCartItems(userId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Add product to cart
  Future<void> addToCart(
      int userId,
      int productId,
      int quantity,
      ) async {
    await _cartService.addToCart(
      userId,
      productId,
      quantity,
    );

    await loadCart(userId);
  }

  // Increase quantity
  Future<void> increaseQuantity(
      int userId,
      int cartId,
      int currentQuantity,
      ) async {
    await _cartService.updateCartQuantity(
      cartId,
      currentQuantity + 1,
    );

    await loadCart(userId);
  }

  // Decrease quantity
  Future<void> decreaseQuantity(
      int userId,
      int cartId,
      int currentQuantity,
      ) async {
    if (currentQuantity <= 1) {
      return;
    }

    await _cartService.updateCartQuantity(
      cartId,
      currentQuantity - 1,
    );

    await loadCart(userId);
  }

  // Delete item
  Future<void> deleteItem(
      int userId,
      int cartId,
      ) async {
    await _cartService.deleteCartItem(cartId);

    await loadCart(userId);
  }

  // Clear cart
  Future<void> clearCart(int userId) async {
    await _cartService.clearCart(userId);

    await loadCart(userId);
  }
}