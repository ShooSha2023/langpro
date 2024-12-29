import 'dart:io'; // لدعم التعامل مع ملفات الصور
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pro/pages/CheckOut.dart';
import 'package:pro/pages/MainScreen.dart';
import 'package:pro/widgets/buildTextField.dart';
import 'package:pro/widgets/LocationDropdown.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  File? _profileImage;
  String? _selectedLocation;

  Future<void> _requestPermission() async {
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
        body: SingleChildScrollView(
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
                            ? FileImage(_profileImage!)
                            : AssetImage('images/hello.jpg'), //as ImageProvider
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
                ),
                SizedBox(height: 24),
                buildTextField(
                  label: 'Last Name',
                  hintText: 'Enter your last name',
                  icon: Icons.person_3_rounded,
                ),
                SizedBox(height: 24),
                buildTextField(
                  label: 'Phone Number',
                  hintText: 'Enter your phone number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 24),
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
                  onLocationChanged: (selectedLocation) {
                    setState(() {
                      _selectedLocation = selectedLocation;
                    });
                    print('Selected location: $selectedLocation');
                  },
                ),
                if (_selectedLocation != null) ...[
                  SizedBox(height: 24),
                  buildTextField(
                    label: 'Location Details',
                    hintText: 'Enter details for the selected location',
                    icon: Icons.location_on,
                  ),
                ],
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    onPressed: () {},
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Checkout()),
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
          ],
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
