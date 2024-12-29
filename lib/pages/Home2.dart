// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pro/Shared/AppBar.dart';
import 'package:pro/model/item.dart';
import 'package:pro/model/store.dart';
import 'package:pro/pages/SearchPageProduct.dart';
import 'package:pro/pages/details_screen.dart';
import 'package:pro/provider/cart.dart';
import 'package:provider/provider.dart';

class Home2 extends StatefulWidget {
  final Store store;
  Home2({required this.store});

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  TextEditingController _searchController = TextEditingController();
  List<Item> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = getItemsForStore(widget.store.id);
    _searchController.addListener(() {
      setState(() {
        filteredItems = getItemsForStore(widget.store.id)
            .where((item) => item.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  List<Item> getItemsForStore(int storeId) {
    return items.where((item) => item.storeId == storeId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Cartt = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.store.name,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          ProductsAndPrice(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SearchProductsPage(store: widget.store),
                    ));
              },
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No products found!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = filteredItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Details(product: item)));
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side:
                                  BorderSide(color: Colors.orange, width: 1.5),
                            ),
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    item.imgPath,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              title: Text(item.name),
                              subtitle: Text(item.price.toString()),
                              trailing: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  Cartt.add(item);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
