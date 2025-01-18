import 'package:flutter/material.dart';
import 'package:pro/Shared/AppBar.dart';
import 'package:pro/model/item.dart';
import 'package:pro/provider/cartProvider.dart';
import 'package:pro/provider/favProvider.dart';
import 'package:pro/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Details extends StatefulWidget {
  final int productId;

  Details({required this.productId});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Item? product;
  bool isLoading = true;
  bool isShowMore = true;
  int quantity = 1; // المتغير لتخزين كمية المنتج

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/product/${widget.productId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data']; // هنا البيانات هي كائن وليس قائمة

        // تحقق من وجود البيانات
        if (data != null) {
          setState(() {
            product = Item.fromJson(data);
            isLoading = false;
          });
        } else {
          throw Exception('No product data found');
        }
      } else {
        throw Exception(
            'Failed to load product details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(product!, quantity);
    showNotification('$quantity Products added to cart!');
    Navigator.pop(context);
    Future.delayed(Duration(seconds: 3), () {
      // العودة إلى صفحة المنتجات
    });
  }

  @override
  Widget build(BuildContext context) {
    final Fav = Provider.of<Favorites>(context);
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (product == null) {
      return Center(child: Text('nothing to show!'));
    }

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [ProductsAndPrice()],
        backgroundColor: Colors.orange,
        title: Text(product!.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product!.photo),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '\$${product!.price}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                Container(
                  padding: EdgeInsets.only(left: 150),
                  child: IconButton(
                    icon: Icon(
                      Fav.isFavorite(product!.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Fav.isFavorite(product!.id) ? Colors.orange : null,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        if (Fav.isFavorite(product!.id)) {
                          Fav.removeFromFavorites(product!);
                        } else {
                          Fav.addToFavorites(product!.id);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Details:',
              style: TextStyle(fontSize: 22, color: Colors.orange),
            ),
            SizedBox(height: 12),
            Text(
              product!.description,
              style: TextStyle(fontSize: 18, color: Colors.black45),
              maxLines: isShowMore ? 1 : null,
              overflow: TextOverflow.fade,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isShowMore = !isShowMore;
                });
              },
              child: Text(
                isShowMore ? "Show more" : "Show less",
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 80),
            // قسم الكمية
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline_rounded),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: addToCart,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 30),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Add $quantity to Cart',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline_rounded),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
