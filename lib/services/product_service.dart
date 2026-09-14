import '../database/database_helper.dart';

class ProductService {
  final DatabaseHelper _database = DatabaseHelper.instance;

  // Get all products
  Future<List<Map<String, dynamic>>> getProducts() {
    return _database.searchProducts('');
  }

  // Search products
  Future<List<Map<String, dynamic>>> searchProducts(
      String query,
      ) {
    return _database.searchProducts(query);
  }

  // Get products by category
  Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category,
      ) {
    return _database.getProductsByCategory(category);
  }
}