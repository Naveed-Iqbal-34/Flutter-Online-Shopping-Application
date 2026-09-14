import '../database/database_helper.dart';

class CartService {
  final DatabaseHelper _database = DatabaseHelper.instance;

  // Get all cart items for a user
  Future<List<Map<String, dynamic>>> getCartItems(int userId) {
    return _database.getCartItems(userId);
  }

  // Add product to cart
  Future<void> addToCart(
      int userId,
      int productId,
      int quantity,
      ) {
    return _database.addToCart(
      userId,
      productId,
      quantity,
    );
  }

  // Update cart quantity
  Future<void> updateCartQuantity(
      int cartId,
      int quantity,
      ) {
    return _database.updateCartQuantity(
      cartId,
      quantity,
    );
  }

  // Delete one cart item
  Future<void> deleteCartItem(int cartId) {
    return _database.deleteCartItem(cartId);
  }

  // Clear user's entire cart
  Future<void> clearCart(int userId) {
    return _database.clearCart(userId);
  }
}