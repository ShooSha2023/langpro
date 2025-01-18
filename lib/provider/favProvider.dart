import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/model/favitem.dart';
import 'package:pro/model/item.dart';
import 'package:pro/pages/favourite.dart';
import 'package:pro/services/api_service.dart';

class Favorites with ChangeNotifier {
  final FavService _apiService = FavService();
  List<FavoriteItem> _favoriteItems = [];
  List<Item> _favoriteProducts = [];

  List<FavoriteItem> get favoriteItems => _favoriteItems;
  List<Item> get favoriteProducts => _favoriteProducts;
  Map<int, bool> _favoriteStatus = {}; // تخزين حالة المفضلة لكل منتج

  // ت
  bool isLoading = false; // متغير للتأكد من حالة التحميل
  bool hasFavorites = false; // متغير للتأكد من وجود العناصر

  Future<void> fetchFavorites() async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    isLoading = true; // تعيين حالة التحميل
    notifyListeners();

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getFavorites'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      print(response.body);

      // تأكد من وجود الحقل 'message' في الاستجابة
      if (decodedResponse['message'] != null) {
        final List<dynamic> data = decodedResponse['message'];
        print(data);
        _favoriteItems =
            data.map((json) => FavoriteItem.fromJson(json)).toList();

        List<Item> products = [];
        for (var item in _favoriteItems) {
          final product = await fetchProductById(item.productId);
          if (product != null) {
            products.add(product);
            _favoriteStatus[product.id] = true; // تعيين الحالة إلى مفضل
          }
        }

        _favoriteProducts = products;

        // تحقق مما إذا كانت قائمة المفضلة فارغة
        hasFavorites = _favoriteProducts.isNotEmpty;
      } else {
        throw Exception('No favorites found in the response');
      }
    } else {
      throw Exception('Failed to load favorites: ${response.statusCode}');
    }

    isLoading = false; // إنهاء حالة التحميل
    notifyListeners();
  }

  Future<Item?> fetchProductById(int productId) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/product/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response received: ${response.body}'); // طباعة الاستجابة لفحصها

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // تأكد من أن الحقول المطلوبة موجودة
        if (jsonResponse['data'] != null) {
          return Item.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Product data is null');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchProductById: $e');
      return null; // إرجاع null في حالة حدوث خطأ
    }
  }

  // إضافة منتج إلى المفضلة
  Future<void> addToFavorites(int productId) async {
    try {
      await _apiService.addToFavorites(productId);
      _favoriteStatus[productId] = true; // تعيين الحالة إلى مفضل
      fetchFavorites(); // تحديث قائمة المفضلة بعد الإضافة
    } catch (e) {
      throw Exception('Failed to add to favorites');
    }
  }

  // إزالة منتج من المفضلة
  Future<void> removeFromFavorites(Item product) async {
    try {
      await _apiService.removeFromFavorites(product.id);
      _favoriteStatus[product.id] = false; // تعيين الحالة إلى غير مفضل
      fetchFavorites();
    } catch (e) {
      throw Exception('Failed to remove from favorites');
    }
  }

  // إزالة جميع المنتجات من المفضلة
  Future<void> removeAllFavorites() async {
    try {
      await _apiService.removeAllFavorites();
      _favoriteProducts = [];
      notifyListeners(); // تحديث الحالة
    } catch (e) {
      throw Exception('Failed to remove all favorites');
    }
  }

  bool isFavorite(int productId) {
    return _favoriteStatus[productId] ?? false; // تحقق من الحالة
  }

  // مسح قائمة المفضلة محليًا
  void clearFavorites() {
    _favoriteProducts = [];
    notifyListeners();
  }
}
