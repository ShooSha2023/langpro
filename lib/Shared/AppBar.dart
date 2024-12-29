



import 'package:flutter/material.dart';
import 'package:pro/model/item.dart';
import 'package:pro/pages/CheckOut.dart';
import 'package:pro/pages/details_screen.dart';
import 'package:pro/provider/cart.dart';
import 'package:provider/provider.dart';

class ProductsAndPrice extends StatelessWidget {
  const ProductsAndPrice({super.key});

  @override
  Widget build(BuildContext context) { 
    // ignore: non_constant_identifier_names
    final Cartt = Provider.of<Cart>(context);
    return  Row(
            children: [
                  Stack(
                children: [
                  Positioned(
                    bottom: 24,
                    child: Container(
                      child: Text(
                        '${Cartt.selectedProducts.length}',
                        style: const TextStyle(
                            fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
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
                          MaterialPageRoute(builder: (context)=>Checkout(),
                        ),);
                      }, 
                      icon: Icon(Icons.add_shopping_cart)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  '\$ ${Cartt.price}',
                  style: TextStyle(fontSize: 18),
                ),
              ), 
            ],
          );
  }
}