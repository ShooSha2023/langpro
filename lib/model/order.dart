import 'package:pro/model/orderitem.dart';

class Order {
  final int id;
  final int userId;
  final int storeId;
  final String orderNumber;
  final double totalAmount;
  final String location;
  final String paymentInfo;
  final String description;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String orderIdentifier;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.orderNumber,
    required this.totalAmount,
    required this.location,
    required this.paymentInfo,
    required this.description,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.orderIdentifier,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var orderItemsJson = json['order_items'] as List;
    List<OrderItem> orderItemsList =
        orderItemsJson.map((item) => OrderItem.fromJson(item)).toList();

    return Order(
      id: json['id'],
      userId: json['userId'],
      storeId: json['storeId'],
      orderNumber: json['order_number'],
      totalAmount: double.parse(json['total_amount']),
      location: json['location'],
      paymentInfo: json['payment_info'],
      description: json['description'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      orderIdentifier: json['order_identifier'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      orderItems: orderItemsList,
    );
  }
}
