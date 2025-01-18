import 'dart:io'; // لدعم التعامل مع ملفات الصور
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pro/pages/CheckOut.dart';
import 'package:pro/pages/MainScreen.dart';
import 'package:pro/pages/logout.dart';
import 'package:pro/pages/orderHistory.dart';
import 'package:pro/services/api_service.dart';
import 'package:pro/widgets/buildTextField.dart';
import 'package:pro/widgets/LocationDropdown.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String? _profileImageUrl;
  String? _firstName,
      _lastName,
      _phoneNumber,
      _government,
      _locationDescription;
  bool _isLoading = true;

  final ProfileService _profileService =
      ProfileService(); // استدعاء الـ ProfileService

  Future<void> _requestPermission() async {
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
  }

  // استرجاع بيانات المستخدم عند فتح الصفحة
  Future<void> _fetchUserProfile() async {
    try {
      final profileData = await TokenManager.getUserData();
      print(profileData);
      // التحقق من البيانات قبل تعيينها
      if (profileData != null) {
        setState(() {
          _firstName = profileData['name'] ?? '';
          _lastName = profileData['lastName'] ?? '';
          _phoneNumber = profileData['phoneNumber'] ?? '';
          _government = profileData['government'] ?? '';
          _locationDescription = profileData['locationDescription'] ?? '';
          _profileImageUrl = profileData['photo'] != null
              ? profileData['photo'] // إذا كان URL مباشر
              : null; // أو تعيين صورة افتراضية إذا كانت null;
        });
      } else {
        print('No profile data found');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      setState(() {
        _isLoading = false; // إيقاف مؤشر التحميل
      });
    }
  }

  // التقاط صورة الملف الشخصي
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  // تحديث بيانات المستخدم
  Future<void> _updateProfile() async {
    try {
      bool success = await _profileService.updateUserProfile(
        firstName: _firstName ?? '',
        lastName: _lastName ?? '',
        profileImage: _profileImage,
        // location: _selectedLocation ?? '',
        government: _government ?? '',
        locationDescription: _locationDescription ?? '',
      );
      if (success) {
        showNotification('Profile updated successfully!'); // عرض الرسالة
      } else {
        showNotification(
            'Failed to update profile. Please try again.'); // عرض الرسالة عند الفشل
      }
    } catch (e) {
      showNotification('Error: $e'); // عرض الرسالة عند الخطأ
    }
  }
  //     if (success) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             content: Text('Profile updated successfully!'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // إغلاق الحوار
  //                 },
  //                 child: Text('OK',
  //                     style: TextStyle(
  //                       color: Colors.orange,
  //                     )),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       await Future.delayed(Duration(milliseconds: 100)); // تأخير بسيط
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to update profile. Please try again.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     await Future.delayed(Duration(milliseconds: 100)); // تأخير بسيط
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: $e'),
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 1;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          title: Text(
            'My Profile',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.orange,
          automaticallyImplyLeading: false,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 78,
                            backgroundColor: Colors.orange[500],
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage: _profileImage != null
                                  ? FileImage(
                                      _profileImage!) // إذا كانت صورة الملف موجودة
                                  : _profileImageUrl != null
                                      ? NetworkImage(
                                          _profileImageUrl!) // إذا كانت صورة الـ URL موجودة
                                      : AssetImage(
                                          'images/hello.jpg'), // إذا كانت كل الصور فارغة، اعرض الصورة الافتراضية

                              backgroundColor: Colors.orange[400],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.orange,
                              size: 30,
                            ),
                            onPressed: _pickImage,
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      buildTextField(
                        label: 'First Name',
                        hintText: 'Enter your first name',
                        icon: Icons.person_3_rounded,
                        initialValue:
                            _firstName ?? '', // تأكد من أن هذه القيم ليست null
                        onChanged: (value) => _firstName = value,
                      ),
                      SizedBox(height: 18),
                      buildTextField(
                        label: 'Last Name',
                        hintText: 'Enter your last name',
                        icon: Icons.person_3_rounded,
                        initialValue: _lastName ?? '',
                        onChanged: (value) => _lastName = value,
                      ),
                      SizedBox(height: 18),
                      buildTextField(
                        label: 'Phone Number',
                        hintText: 'Your phone number',
                        icon: Icons.phone,
                        // keyboardType: TextInputType.number,
                        initialValue: _phoneNumber ?? '',
                        enabled: false, // تعيين الحقل كحقل للقراءة فقط
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: null, // إزالة الوظيفة التي تغير القيمة
                      ),
                      SizedBox(height: 18),
                      LocationDropdown(
                        locations: [
                          'Damascus',
                          'Homs',
                          'Hama',
                          'Tartus',
                          'Latakia',
                          'Aleppo',
                          'Al_Sweida',
                          'Daraa',
                          'Idlib',
                          'Qunaitera',
                          'Al_Hasaka',
                          'Al_Raqqa',
                          'Daer_AlZor'
                        ],
                        defaultValue: _government,
                        onLocationChanged: (selectedLocation) {
                          setState(() {
                            _government = selectedLocation;
                          });
                        },
                      ),
                      SizedBox(height: 18),
                      buildTextField(
                        label: 'Location Description',
                        hintText: 'Enter a description for your location',
                        icon: Icons.description,
                        initialValue: _locationDescription ?? '',
                        onChanged: (value) => _locationDescription = value,
                      ),
                      SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ProfilePage()),
              // ).then((_) {
              //   // يتم تنفيذ الكود هنا عند العودة من صفحة الملف الشخصي
              // });
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogoutScreen()),
              );
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
      ),
    );
  }

  void showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60, // مكان الرسالة من أعلى الشاشة
        left: MediaQuery.of(context).size.width * 0.1, // محاذاة إلى اليسار
        right: MediaQuery.of(context).size.width * 0.1, // محاذاة إلى اليمين
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.8), // لون الرسالة
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry); // إدخال الرسالة في overlay

    // إغلاق الرسالة بعد فترة معينة
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
