// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:pro/Shared/AppBar.dart';
import 'package:pro/model/item.dart';
import 'package:pro/provider/cart.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  Item product;
  Details({required this.product});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isShowMore = true;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(actions: [
        //AppBar
        ProductsAndPrice(),
      ], backgroundColor: Colors.orange, title: Text('Details Screen')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(widget.product.imgPath),
            SizedBox(
              height: 11,
            ),
            Text(
              '\$12.99',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    'New',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 129, 129),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Row(
                  children: [
                    Icon(Icons.star,
                        size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                    Icon(Icons.star,
                        size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                    Icon(Icons.star,
                        size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                    Icon(Icons.star,
                        size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                    Icon(Icons.star,
                        size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                  ],
                  //================================
                ),
                SizedBox(
                  width: 66,
                ),
                // Row(
                //   children: [
                //     Icon(
                //       Icons.edit_location,
                //       size: 26,
                //       color: Color.fromARGB(168, 3, 65, 24),
                //     ),
                //     SizedBox(
                //       width: 3,
                //     ),
                //     Text(
                //       widget.product.location,
                //       style: TextStyle(
                //         fontSize: 19,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                'Details: ',
                style: TextStyle(fontSize: 22),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 18),
              maxLines: isShowMore ? 3 : null,
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
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
