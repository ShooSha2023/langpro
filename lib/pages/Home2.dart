import 'package:flutter/material.dart';
import 'package:pro/Shared/AppBar.dart';
import 'package:pro/model/item.dart';
import 'package:pro/model/store.dart';
import 'package:pro/pages/SearchPageProduct.dart';
import 'package:pro/pages/details_screen.dart';
import 'package:pro/provider/cartProvider.dart';
import 'package:pro/provider/favProvider.dart';
import 'package:pro/services/api_service.dart';
import 'package:provider/provider.dart';

class Home2 extends StatefulWidget {
  final Store store;
  Home2({required this.store});

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  TextEditingController _searchController = TextEditingController();
  late Future<List<Item>> futureItems;
  List<int> favoriteIds = []; // قائمة لتخزين معرفات العناصر المفضلة

  @override
  void initState() {
    super.initState();
    futureItems = ProductsService.fetchItems(widget.store.id);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Cartt = Provider.of<CartProvider>(context);
    final Fav = Provider.of<Favorites>(context);
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.store.name,
          style: TextStyle(fontSize: 18),
        ),
        actions: [ProductsAndPrice()],
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
                  ),
                );
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
              child: FutureBuilder<List<Item>>(
                future: futureItems,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load products: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found!',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    );
                  } else {
                    final filteredItems = snapshot.data!;
                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = filteredItems[index];
                        bool isFavorite = favoriteIds
                            .contains(item.id); // تحقق إذا كان مفضلًا

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Details(productId: item.id),
                              ),
                            );
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
                                  child: Image.network(
                                    item.photo,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              title: Text(item.name),
                              subtitle: Text(item.price.toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Fav.isFavorite(item.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Fav.isFavorite(item.id)
                                          ? Colors.red
                                          : null,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (Fav.isFavorite(item.id)) {
                                          Fav.removeFromFavorites(item);
                                        } else {
                                          Fav.addToFavorites(item.id);
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      int amount = 1;
                                      Cartt.addItem(item, amount);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
