import 'package:flutter/material.dart'; // تأكد من المسار الصحيح
import 'package:pro/pages/CheckOut.dart';
import 'package:pro/provider/cartProvider.dart';
import 'package:provider/provider.dart';

class ProductsAndPrice extends StatelessWidget {
  const ProductsAndPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Row(
      children: [
        Stack(
          children: [
            Positioned(
              bottom: 22,
              left: 13,
              child: Container(
                child: Text(
                  '${cartProvider.cartitems.length}', // عدد العناصر في السلة
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(210, 255, 208, 164),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Checkout(),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart_outlined),
              iconSize: 20,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            '\$ ${cartProvider.totalAmount.toStringAsFixed(2)}', // استخدام totalAmount
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
