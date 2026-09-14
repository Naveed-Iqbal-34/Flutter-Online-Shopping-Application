import 'package:flutter/foundation.dart';

import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Map<String, dynamic>> _products = [];

  bool _isLoading = false;

  String _searchQuery = '';

  // ===========================================
  // GETTERS
  // ===========================================

  List<Map<String, dynamic>> get products => _products;

  bool get isLoading => _isLoading;

  String get searchQuery => _searchQuery;

  // ===========================================
  // LOAD PRODUCTS
  // ===========================================

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================
  // SEARCH PRODUCTS
  // ===========================================

  Future<void> searchProducts(String query) async {
    _searchQuery = query;

    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.searchProducts(query);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================
  // PRODUCTS BY CATEGORY
  // ===========================================

  Future<void> loadProductsByCategory(
      String category,
      ) async {
    _isLoading = true;
    notifyListeners();

    try {
      _products =
      await _productService.getProductsByCategory(category);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================
  // CLEAR SEARCH
  // ===========================================

  Future<void> clearSearch() async {
    _searchQuery = '';
    await loadProducts();
  }
}