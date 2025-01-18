import 'package:flutter/material.dart';
import 'package:pro/provider/favProvider.dart';
import 'package:provider/provider.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات من الخادم عند تحميل الواجهة
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await Provider.of<Favorites>(context, listen: false).fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<Favorites>(context);
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange,
        title: Text(
          'My Favourite',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await favProvider.removeAllFavorites();
            },
            icon: Icon(Icons.delete_forever_outlined),
            iconSize: 28,
            hoverColor: Colors.white70,
          ),
        ],
      ),
      body: favProvider.favoriteProducts.isEmpty
          ? Center(child: Text('No favourites found'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: favProvider.favoriteProducts.length,
              itemBuilder: (BuildContext context, int index) {
                final product = favProvider.favoriteProducts[index];
                return Card(
                  child: ListTile(
                    subtitle: Text("${product.price}"),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.photo),
                    ),
                    title: Text(product.name),
                    trailing: IconButton(
                      onPressed: () async {
                        await favProvider.removeFromFavorites(product);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
