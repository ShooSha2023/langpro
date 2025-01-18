import 'dart:convert';

import 'package:pro/model/item.dart';

class FavoriteItem {
  final int id;
  final int userId;
  final int productId;
  final String createdAt;
  final String updatedAt;

  FavoriteItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as int,
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
