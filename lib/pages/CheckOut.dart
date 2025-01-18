import 'package:flutter/material.dart';
import 'package:pro/pages/MainScreen.dart';
import 'package:pro/pages/logout.dart';
import 'package:pro/pages/orderHistory.dart';
import 'package:pro/pages/profile_page.dart';
import 'package:pro/widgets/buildTextField.dart';
import 'package:provider/provider.dart';
import 'package:pro/provider/cartProvider.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int _currentIndex = 2;
  String? selectedPaymentMethod; // متغير لتخزين طريقة الدفع المختارة
  final List<String> paymentMethods = [
    'Credit Card',
    'PayPal',
    'Cash'
  ]; // خيارات الدفع

  @override
  void initState() {
    super.initState();
    final cartt = Provider.of<CartProvider>(context, listen: false);
    cartt.fetchCart();
  }

  void _showOrderConfirmationallSheet() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final TextEditingController locationController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order Confirmation',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                items: paymentMethods
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method,
                              style: TextStyle(color: Color(0xFFEF6C00))),
                        ))
                    .toList(),
                decoration: InputDecoration(
                    labelText: 'Payment Method',
                    labelStyle: TextStyle(color: Colors.orange[800]),
                    hintText: 'Choose your payment method',
                    prefixIcon: Icon(Icons.location_on, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange),
                    )),
                onChanged: (newValue) {
                  setState(() {
                    selectedPaymentMethod =
                        newValue; // تعيين طريقة الدفع المحددة
                  });
                },
              ),
              SizedBox(height: 16),
              buildTextField(
                label: 'location',
                hintText: ' enter your location ',
                icon: Icons.text_snippet,
                controller: locationController,
              ),
              SizedBox(height: 16),
              buildTextField(
                label: 'Details',
                hintText: 'any extra details',
                icon: Icons.wrap_text,
                controller: detailsController,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.orange),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  final location = locationController.text;

                  if (location.isNotEmpty &&
                      selectedPaymentMethod !=
                          null && // التأكد من اختيار طريقة الدفع
                      detailsController.text.isNotEmpty) {
                    await cart.confirmAllOrders(location,
                        selectedPaymentMethod!, detailsController.text);
                    cart.fetchCart();
                    Navigator.pop(context); // إغلاق Bottom Sheet
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                },
                child: Text('Confirm Order'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrderConfirmationSheet(int storeId) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final TextEditingController locationController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order Confirmation',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                items: paymentMethods
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                decoration: InputDecoration(
                    labelText: 'Payment Method',
                    labelStyle: TextStyle(color: Colors.orange[800]),
                    hintText: 'Choose your payment method',
                    prefixIcon: Icon(Icons.location_on, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange),
                    )),
                onChanged: (newValue) {
                  setState(() {
                    selectedPaymentMethod =
                        newValue; // تعيين طريقة الدفع المحددة
                  });
                },
              ),
              SizedBox(height: 16),
              buildTextField(
                label: 'location',
                hintText: ' enter your location ',
                icon: Icons.text_snippet,
                controller: locationController,
              ),
              SizedBox(height: 16),
              buildTextField(
                label: 'Details',
                hintText: 'any extra details',
                icon: Icons.wrap_text,
                controller: detailsController,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.orange),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  final location = locationController.text;

                  if (location.isNotEmpty &&
                      selectedPaymentMethod !=
                          null && // التأكد من اختيار طريقة الدفع
                      detailsController.text.isNotEmpty) {
                    await cart.confirmOrder(storeId, location,
                        selectedPaymentMethod!, detailsController.text);
                    cart.fetchCart();
                    Navigator.pop(context); // إغلاق Bottom Sheet
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                },
                child: Text('Confirm Order'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: Text(
          'My Cart',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              cart.clearCart();
            },
            icon: Icon(Icons.delete_forever_outlined),
            color: Colors.white,
            iconSize: 28,
            hoverColor: Colors.white70,
          ),
        ],
      ),
      body: cart.cartitems.isEmpty
          ? Center(child: Text("Your cart is empty."))
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: cart.cartitems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Colors.orange[300],
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 35,
                              child: CircleAvatar(
                                radius: 23,
                                backgroundImage:
                                    NetworkImage(cart.cartitems[index].photo),
                              ),
                            ),
                            title: Text(cart.cartitems[index].name),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("\$${cart.cartitems[index].price}"),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () async {
                                            if (cart.cartitems[index].amount >
                                                1) {
                                              final newAmount =
                                                  cart.cartitems[index].amount -
                                                      1;
                                              await cart.updateProductAmount(
                                                  cart.cartitems[index]
                                                      .productId,
                                                  newAmount);
                                              cart.fetchCart();
                                            }
                                          },
                                        ),
                                        Text('${cart.cartitems[index].amount}'),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () async {
                                            final newAmount =
                                                cart.cartitems[index].amount +
                                                    1;
                                            await cart.updateProductAmount(
                                                cart.cartitems[index].productId,
                                                newAmount);
                                            cart.fetchCart();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        cart.removeItem(cart.cartitems[index]);
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle_outline_rounded),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // استخدم storeId هنا
                                        _showOrderConfirmationSheet(
                                            cart.cartitems[index].storeId);
                                      },
                                      icon: const Icon(
                                          Icons.check_circle_outline_outlined),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75),
                    child: ElevatedButton(
                      onPressed: () {
                        if (cart.cartitems.isNotEmpty) {
                          // استدعاء Bottom Sheet مع storeId من العنصر الأول في السلة
                          _showOrderConfirmationallSheet();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size(200, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Pay \$${cart.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrderHistoryPage()));
          } else if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LogoutScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off_rounded), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout_outlined), label: 'Logout'),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
