import 'package:flutter/material.dart';
import 'package:pro/model/cartItem.dart';
import 'package:pro/model/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pro/services/api_service.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<Cartitem> _cartitems = [];

  List<Cartitem> get cartitems => _cartitems;
  List<CartItem> get cartItems => _cartItems;
  int get selectedProducts => _cartitems.length;
  double get totalAmount {
    return _cartitems.fold(0, (sum, item) => sum + (item.price * item.amount));
  }

  get price => null;

  // دالة لإضافة عنصر إلى السلة
  Future<void> addItem(Item product, int quantity) async {
    // تحقق مما إذا كان المنتج موجودًا بالفعل في السلة
    int index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // إذا كان المنتج موجودًا، زيادة الكمية
      _cartItems[index].quantity += quantity;
    } else {
      // إذا لم يكن موجودًا، أضف عنصر جديد
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }

    await _updateCartOnServer(product.id, quantity); // تمرير معرف المنتج
    notifyListeners();
    fetchCart();
  }

  // دالة لإرسال السلة إلى الخادم
  Future<void> _updateCartOnServer(int productId, int quantity) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/addToCart/$productId'), // رابط إضافة إلى السلة
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'amount': quantity,
      }),
    );

    // Check the response status and body
    if (response.statusCode != 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update cart on server');
    }
  }

  // دالة لتحديث كمية المنتج
  Future<void> updateProductAmount(int productId, int newAmount) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/update-product-amount/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({"amount": newAmount}),
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to update product amount on server');
    }

    // تحديث الكمية محليًا بعد نجاح العملية
    int index = _cartitems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      _cartItems[index].quantity = newAmount;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    var itemsToRemove = List.from(_cartitems);

    for (var cartitem in itemsToRemove) {
      await removeItem(cartitem); // استدعاء دالة API لإزالة العنصر
    }
    _cartItems.clear(); // تفريغ السلة
    notifyListeners();
    fetchCart();
  }

  // دالة لإزالة عنصر من السلة
  Future<void> removeItem(Cartitem cartitem) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    var productId = cartitem.productId;
    final response = await http.delete(
      Uri.parse(
          'http://127.0.0.1:8000/api/remove-product/$productId'), // رابط إزالة المنتج من السلة
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from cart on server');
    }

    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    fetchCart();
  }

  // دالة لجلب السلة
  Future<void> fetchCart() async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/showCarts'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    } // تأكد من تعديل URL حسب API الخاص بك
            );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      _cartitems = data.map<Cartitem>((item) {
        return Cartitem.fromJson(item);
      }).toList();
      notifyListeners();
      notifyListeners();
    } else {
      throw Exception('Failed to fetch cart from server');
    }
  }

  // دالة لتأكيد الطلب (يمكنك تخصيصها كما تشاء)
  Future<void> confirmOrder(int storeId, String location, String paymentInfo,
      String description) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/submit/$storeId'), // رابط تأكيد الطلب
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'location': location,
        'payment_info': paymentInfo,
        'description': description,
      }),
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to confirm order on server');
    }

    _cartitems.removeWhere((item) => item.storeId == storeId);
    notifyListeners();
  }

  Future<void> confirmAllOrders(
      String location, String paymentInfo, String description) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    // استخراج جميع storeId بشكل فريد
    final storeIds = _cartitems.map((item) => item.storeId).toSet();

    for (final storeId in storeIds) {
      // إرسال الطلب الخاص بكل storeId
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/submit/$storeId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'location': location,
          'payment_info': paymentInfo,
          'description': description,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to confirm order for storeId $storeId on server');
      }

      // تفريغ السلة بعد تأكيد جميع الطلبات
      _cartitems.clear();
      notifyListeners();
    }
  }
}

class CartItem {
  final Item product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
