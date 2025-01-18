import 'dart:convert';

class Item {
  int id;
  int storeId;
  String name;
  String photo;
  double price;
  String description;
  int amount;

  Item({
    required this.id,
    required this.storeId,
    required this.name,
    required this.photo,
    required this.price,
    required this.description,
    required this.amount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      storeId: json['storeId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: double.tryParse(json['price']) ?? 0.0, // تحويل السعر إلى double
      photo: json['photo'] as String,
      amount: json['amount'] as int,
    );
  }
}
