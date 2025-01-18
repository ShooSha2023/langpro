import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro/pages/MainScreen.dart';
import 'package:pro/pages/login_screen.dart';
import 'package:pro/widgets/LocationDropdown.dart';
import 'package:pro/widgets/buildTextField.dart';
import 'package:pro/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  late String _government;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationDescriptionController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/signup.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 136, 0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create your account",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 90),
                    child: buildTextField(
                      controller: _firstNameController,
                      label: 'First name',
                      hintText: 'enter your first name',
                      icon: Icons.person_outline_outlined,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: buildTextField(
                      controller: _lastNameController,
                      label: 'Last name',
                      hintText: 'enter your last name',
                      icon: Icons.person_outline_outlined,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: buildTextField(
                      controller: _phoneController,
                      label: 'Phone number',
                      hintText: 'enter your Phone number',
                      icon: Icons.phone_iphone_rounded,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(height: 10),
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
                        _government = selectedLocation;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    controller: _locationDescriptionController,
                    label: 'Location Description',
                    hintText: 'enter your location description',
                    icon: Icons.location_city_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildPasswordField(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _buildConfirmPasswordField(),
                  ),
                  const SizedBox(height: 15),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 40),
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 136, 0),
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 235, 235),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      LoginScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 136, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: Color(0xFFEF6C00)),
      decoration: InputDecoration(
        labelText: 'password',
        labelStyle: TextStyle(color: Color(0xFFEF6C00)),
        hintText: 'create your password',
        prefixIcon:
            const Icon(Icons.lock_person_outlined, color: Colors.orange),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Color(0xFFEF6C00),
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: Color(0xFFEF6C00)),
      decoration: InputDecoration(
        labelText: 'confirm password',
        labelStyle: TextStyle(color: Colors.orange[800]),
        hintText: 'reEnter your password',
        prefixIcon:
            const Icon(Icons.lock_person_outlined, color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }

  void _register() async {
    setState(() {
      _errorMessage = null;
    });

    bool areFieldsFilled = _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _government.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;

    if (!areFieldsFilled) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    bool isPasswordMatch =
        _passwordController.text == _confirmPasswordController.text;
    if (!isPasswordMatch) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    try {
      bool success = await ApiService.registerUser(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        government: _government,
        locationDescription: _locationDescriptionController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to register. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }
}
