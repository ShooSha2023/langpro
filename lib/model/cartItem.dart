import 'package:pro/model/item.dart';

class Cartitem {
  final int id;
  final int userId;
  final int productId;
  final String name;
  final String photo;
  final double price;
  final String description;
  int amount; // يجب أن تكون قابلة للتعديل
  final int storeId; // استخدام camelCase
  final String createdAt; // استخدام camelCase
  final String updatedAt; // استخدام camelCase
  Item? cartitem;

  Cartitem({
    required this.id,
    required this.storeId,
    required this.name,
    required this.photo,
    required this.price,
    required this.description,
    required this.amount,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Cartitem.fromJson(Map<String, dynamic> json) {
    return Cartitem(
      id: json['id'] as int,
      storeId: json['store_id'] as int,
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: double.tryParse(json['price']) ?? 0.0,
      photo: json['photo'] as String,
      amount: json['amount'] as int,
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
