import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/services/api_service.dart';

class Notification {
  final String id;
  final String orderId;
  final String orderStatus;
  final String orderNumber;
  final String message;
  final String createdAt;

  Notification({
    required this.id,
    required this.orderId,
    required this.orderStatus,
    required this.orderNumber,
    required this.message,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    final data = jsonDecode(json['data']);
    return Notification(
      id: json['id'],
      orderId: data['order_id'].toString(),
      orderStatus: data['order_status'],
      orderNumber: data['order_number'],
      message: data['message'],
      createdAt: json['created_at'],
    );
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Notification> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchUserNotifications();
  }

  Future<void> fetchUserNotifications() async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getUserNotifications'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> notificationsJson = jsonResponse['data'];
      setState(() {
        notifications = notificationsJson
            .map((notification) => Notification.fromJson(notification))
            .toList();
      });
    } else {
      print(response.body);
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> deleteNotification(String orderId) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/setNotificationsRead/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Notification deleted successfully');
      setState(() {
        notifications.removeWhere((notification) =>
            notification.id == orderId); // تحديث القائمة محليًا
      });
    } else {
      print(response.body);
      throw Exception('Failed to delete notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                  'No notifications found.')) // رسالة عندما تكون قائمة الإشعارات فارغة

          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification.message),
                  subtitle: Text(
                    'Order Number: ${notification.orderNumber}\nStatus: ${notification.orderStatus}\nDate: ${notification.createdAt}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // تأكيد الحذف
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Notification'),
                            content: Text(
                                'Are you sure you want to delete this notification?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // أغلق الحوار
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await deleteNotification(notification.id);
                                  Navigator.of(context).pop(); // أغلق الحوار
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  onTap: () {
                    // هنا يمكنك إضافة الكود للانتقال إلى تفاصيل الإشعار
                  },
                );
              },
            ),
    );
  }
}
