import 'package:flutter/material.dart';
import 'package:pro/pages/CheckOut.dart';
import 'package:pro/pages/MainScreen.dart';
import 'package:pro/pages/login_screen.dart';
import 'package:pro/pages/orderHistory.dart';
import 'package:pro/pages/profile_page.dart';
import 'package:pro/services/api_service.dart';
import 'package:pro/widgets/buildTextField.dart';

class LogoutScreen extends StatefulWidget {
  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordValid = true;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
      _isPasswordValid = true; // Reset password validation
    });

    try {
      // Perform logout using the AuthService
      bool success = await _authService.logout(
        _passwordController.text,
      );
      if (success) {
        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "You have logged out successfully!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                const Color.fromARGB(107, 255, 153, 0), // لون مناسب للنجاح
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to the login screen after a short delay
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _isPasswordValid = false; // Show error if password is invalid
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect password, please try again'),
          backgroundColor:
              const Color.fromARGB(91, 244, 67, 54), // لون مناسب للأخطاء
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.deleteAccount(); // استخدم الدالة لحذف الحساب
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your account has been deleted successfully!'),
          backgroundColor:
              const Color.fromARGB(107, 255, 153, 0), // لون مناسب للنجاح
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate to the login screen after deletion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account: $e'),
          backgroundColor:
              const Color.fromARGB(91, 244, 67, 54), // لون مناسب للأخطاء
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm Deletion',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق مربع التأكيد
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع التأكيد
                _deleteAccount(); // استدعاء دالة الحذف
              },
              child: Text('Delete',
                  style: TextStyle(
                    color: Colors.red,
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 4;
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Are you sure you want to log out?",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: 'Confirm Password',
              hintText: 'Enter your password',
              icon: Icons.lock,
              controller: _passwordController,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: _logout,
                    child: Text(
                      "Confirm Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // لون الزر لحذف الحساب
                    ),
                    onPressed: _confirmDeleteAccount,
                    child: Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
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
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            ).then((_) {
              // يتم تنفيذ الكود هنا عند العودة من صفحة الملف الشخصي
            });
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Checkout()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryPage()),
            );
          } else if (index == 4) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => LogoutScreen()),
            // );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off_rounded),
            label: 'history',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_outlined),
            label: 'logout',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
