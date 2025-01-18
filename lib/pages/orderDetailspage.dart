import 'package:flutter/material.dart';
import 'package:pro/model/order.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  OrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50], // خلفية لتشابه التصميم
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Order Details',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Amount: \$${order.totalAmount}',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Location: ${order.location}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Date: ${order.createdAt.toLocal()}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Products:',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: order.orderItems.length,
                itemBuilder: (context, index) {
                  final item = order.orderItems[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16.0), // حواف مدورة
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      color:
                          Colors.orange[300], // تغيير اللون ليتناسب مع التصميم
                      child: ListTile(
                        textColor: Colors.black45,
                        title: Text('Product ID: ${item.productId}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Quantity: ${item.quantity} - Price: \$${item.price}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            )),
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
