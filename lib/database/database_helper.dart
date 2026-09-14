import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // =========================================================
  // DATABASE INSTANCE
  // =========================================================

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // =========================================================
  // GET DATABASE
  // =========================================================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('shopeasy.db');

    return _database!;
  }

  // =========================================================
  // INITIALIZE DATABASE
  // =========================================================

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // =========================================================
  // CREATE TABLES
  // =========================================================

  Future<void> _createDB(
      Database db,
      int version,
      ) async {

    // -------------------------------------------------------
    // USERS TABLE
    // -------------------------------------------------------

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    // -------------------------------------------------------
    // PRODUCTS TABLE
    // -------------------------------------------------------

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        rating REAL,
        category TEXT,
        imagePath TEXT
      )
    ''');

    // -------------------------------------------------------
    // CART TABLE
    // -------------------------------------------------------

    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        productId INTEGER,
        quantity INTEGER
      )
    ''');

    // =======================================================
    // TEST USER
    // =======================================================

    await db.insert(
      'users',
      {
        'username': 'test@gmail.com',
        'password': 'password123',
      },
    );

    // =======================================================
    // PRODUCTS
    // =======================================================

    await db.insert(
      'products',
      {
        'name': 'Headphone',
        'price': 4000.0,
        'rating': 4.5,
        'category': 'Electronics',
        'imagePath': 'assets/images/headphones.png',
      },
    );

    await db.insert(
      'products',
      {
        'name': 'Smartphone',
        'price': 45000.0,
        'rating': 4.5,
        'category': 'Electronics',
        'imagePath': 'assets/images/phone.png',
      },
    );

    await db.insert(
      'products',
      {
        'name': 'Laptop Computer',
        'price': 50000.0,
        'rating': 4.5,
        'category': 'Electronics',
        'imagePath': 'assets/images/laptop.png',
      },
    );

    await db.insert(
      'products',
      {
        'name': 'Designer Shoes',
        'price': 4000.0,
        'rating': 4.5,
        'category': 'Fashion',
        'imagePath': 'assets/images/shoes.png',
      },
    );
    await db.insert('products', {
      'name': 'Wireless Earbuds',
      'price': 3500,
      'rating': 4.3,
      'category': 'Electronics',
      'imagePath': 'assets/images/earbuds.png',
    });

    await db.insert('products', {
      'name': 'Gaming Mouse',
      'price': 2500,
      'rating': 4.4,
      'category': 'Electronics',
      'imagePath': 'assets/images/mouse.jpg',
    });

    await db.insert('products', {
      'name': 'Men Sneakers',
      'price': 5000,
      'rating': 4.5,
      'category': 'Fashion',
      'imagePath': 'assets/images/sneakers.png',
    });

    await db.insert('products', {
      'name': 'Leather Jacket',
      'price': 8500,
      'rating': 4.7,
      'category': 'Fashion',
      'imagePath': 'assets/images/jacket.jpg',
    });

    await db.insert('products', {
      'name': 'Smart Watch',
      'price': 6500,
      'rating': 4.6,
      'category': 'Electronics',
      'imagePath': 'assets/images/watch.jpg',
    });

  }

  // =========================================================
  // USER METHODS
  // =========================================================

  // ---------------------------------------------------------
  // REGISTER USER
  // ---------------------------------------------------------

  Future<int> registerUser(
      String username,
      String password,
      ) async {
    final db = await instance.database;

    try {
      return await db.insert(
        'users',
        {
          'username': username,
          'password': password,
        },
      );
    } catch (e) {
      return -1;
    }
  }

  // ---------------------------------------------------------
  // LOGIN USER
  // ---------------------------------------------------------

  Future<Map<String, dynamic>?> loginUser(
      String username,
      String password,
      ) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [
        username,
        password,
      ],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // ---------------------------------------------------------
// GET USER
// ---------------------------------------------------------

  Future<Map<String, dynamic>?> getUser(
      String username,
      ) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // =========================================================
  // PRODUCT METHODS
  // =========================================================

  // ---------------------------------------------------------
  // SEARCH PRODUCTS
  // ---------------------------------------------------------

  Future<List<Map<String, dynamic>>> searchProducts(
      String query,
      ) async {
    final db = await instance.database;

    if (query.isEmpty) {
      return await db.query('products');
    }

    return await db.query(
      'products',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
  }

  // ---------------------------------------------------------
  // GET PRODUCTS BY CATEGORY
  // ---------------------------------------------------------

  Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category,
      ) async {
    final db = await instance.database;

    return await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  // =========================================================
  // CART METHODS
  // =========================================================

  // ---------------------------------------------------------
  // ADD PRODUCT TO CART
  // ---------------------------------------------------------

  Future<void> addToCart(
      int userId,
      int productId,
      int quantity,
      ) async {
    final db = await instance.database;

    // Check if product is already in cart
    final existing = await db.query(
      'cart',
      where: 'userId = ? AND productId = ?',
      whereArgs: [
        userId,
        productId,
      ],
    );

    if (existing.isNotEmpty) {

      // Product already exists
      // Increase its quantity

      final oldQuantity =
      existing.first['quantity'] as int;

      await db.update(
        'cart',
        {
          'quantity': oldQuantity + quantity,
        },
        where: 'userId = ? AND productId = ?',
        whereArgs: [
          userId,
          productId,
        ],
      );

    } else {

      // Product doesn't exist
      // Add a new cart item

      await db.insert(
        'cart',
        {
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
        },
      );
    }
  }

  // ---------------------------------------------------------
  // GET CART ITEMS
  // ---------------------------------------------------------

  Future<List<Map<String, dynamic>>> getCartItems(
      int userId,
      ) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT
        cart.id AS cartId,
        cart.userId,
        cart.productId,
        cart.quantity,
        products.name,
        products.price,
        products.rating,
        products.category,
        products.imagePath
      FROM cart

      INNER JOIN products
        ON cart.productId = products.id

      WHERE cart.userId = ?
    ''', [
      userId,
    ]);

    return result;
  }

  // ---------------------------------------------------------
  // UPDATE CART QUANTITY
  // ---------------------------------------------------------

  Future<void> updateCartQuantity(
      int cartId,
      int quantity,
      ) async {
    final db = await instance.database;

    await db.update(
      'cart',
      {
        'quantity': quantity,
      },
      where: 'id = ?',
      whereArgs: [
        cartId,
      ],
    );
  }

  // ---------------------------------------------------------
  // DELETE ONE CART ITEM
  // ---------------------------------------------------------

  Future<void> deleteCartItem(
      int cartId,
      ) async {
    final db = await instance.database;

    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [
        cartId,
      ],
    );
  }

  // ---------------------------------------------------------
  // CLEAR ENTIRE CART
  // ---------------------------------------------------------

  Future<void> clearCart(
      int userId,
      ) async {
    final db = await instance.database;

    await db.delete(
      'cart',
      where: 'userId = ?',
      whereArgs: [
        userId,
      ],
    );
  }
}