import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pro/model/favitem.dart';
import 'package:pro/model/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pro/model/item.dart';

class TokenManager {
  static const String _tokenKey = 'userToken';
  static const String _userDataKey = 'userData';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }
}

class ApiService {
  static const String _baseUrl = "http://127.0.0.1:8000/api";

  static Future<bool> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String government,
    required String locationDescription,
    required String password,
    required String passwordConfirmation,
  }) async {
    final String apiUrl = '$_baseUrl/register';

    try {
      final headers = {
        "Content-Type": "application/json",
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({
          "name": firstName,
          "lastName": lastName,
          "phoneNumber": phone,
          "government": government,
          "locationDescription": locationDescription,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Response Body: ${response.body}");

        var responseData = jsonDecode(response.body);

        if (responseData.containsKey('token')) {
          String token = responseData['token'];
          await TokenManager.saveToken(token);
          return true;
        } else {
          print("Token not found in the response.");
          return false;
        }
      } else {
        print("Failed to register. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}

class LoginService {
  static const String _baseUrl = "http://127.0.0.1:8000/api";
  static Future<bool> loginUser({
    required String phone,
    required String password,
  }) async {
    final String apiUrl = '$_baseUrl/login';

    try {
      final headers = {
        "Content-Type": "application/json",
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({
          "phoneNumber": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);

        if (responseData.containsKey('token')) {
          String token = responseData['token'];
          await TokenManager.saveToken(token);

          if (responseData.containsKey('data')) {
            await TokenManager.saveUserData(responseData['data']);
          }

          return true;
        } else {
          print("Token not found in the response.");
          return false;
        }
      } else {
        print("Login failed. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}

class AuthService {
  Future<bool> logout(String password) async {
    final String apiUrl = "http://127.0.0.1:8000/api/logout";

    try {
      // استرجاع التوكن من التخزين
      String? token = await TokenManager.getToken();

      if (token == null) {
        throw Exception("No valid token found. Please log in.");
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // التحقق من استجابة الـ API
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          // في حالة النجاح
          await TokenManager.saveToken(""); // مسح التوكن
          return true;
        } else {
          throw Exception(responseData['message'] ?? "Logout failed");
        }
      } else if (response.statusCode == 401) {
        throw Exception("Invalid password");
      } else {
        throw Exception(
            "Failed to log out. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during logout: $e");
    }
  }

  Future<void> deleteAccount() async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/deleteProfile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account');
    }
  }
}

class StoreService {
  static Future<List<Store>> fetchStores() async {
    String? token = await TokenManager.getToken();

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/home'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> storesData = data['data'];

      return storesData.map((storeJson) => Store.fromJson(storeJson)).toList();
    } else {
      throw Exception('Failed to load stores');
    }
  }
}

class ProductsService {
  static Future<List<Item>> fetchItems(int storeId) async {
    String? token = await TokenManager.getToken();

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/store/$storeId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData['status'] == true && jsonData['data'] != null) {
        final List<dynamic> itemsData = jsonData['data'];
        return itemsData.map((item) => Item.fromJson(item)).toList();
      } else {
        throw Exception('Failed to parse items');
      }
    } else {
      throw Exception(
          'Failed to load items: ${response.statusCode}, ${response.body}');
    }
  }

  Future<Item?> fetchProductById(int productId) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    try {
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/product/$productId'), // تأكد من أن هذا هو الرابط الصحيح لجلب المنتج
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Item.fromJson(
            json.decode(response.body)); // تحويل البيانات إلى كائن Product
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchProductById: $e');
      return null; // إرجاع null في حالة حدوث خطأ
    }
  }
}

class ProfileService {
  static const String baseUrl = "http://127.0.0.1:8000/api";
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> updateUserProfile({
    required String firstName,
    required String lastName,
    File? profileImage,
    // required String location,
    required String government,
    required String locationDescription,
  }) async {
    try {
      final token = await TokenManager.getToken();
      final currentUserData = await TokenManager.getUserData();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/updateProfile'), // رابط API
      );

      // إضافة التوكن إلى الـ Headers
      request.headers['Authorization'] = 'Bearer $token';

      // إرسال الحقول التي تم تعديلها فقط
      if (firstName != currentUserData?['first_name']) {
        request.fields['name'] = firstName;
      }
      if (lastName != currentUserData?['last_name']) {
        request.fields['lastName'] = lastName;
      }
      // if (location != currentUserData?['location']) {
      //   request.fields['location'] = location;
      // }
      if (government != currentUserData?['government']) {
        request.fields['government'] = government;
      }
      if (locationDescription != currentUserData?['locationDescription']) {
        request.fields['locationDescription'] = locationDescription;
      }

      // رفع الصورة إذا تم تعديلها
      if (profileImage != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'photo', // اسم الحقل الذي يطلبه الـ API
          profileImage.path,
        );
        request.files.add(multipartFile);
      }

      // إرسال الطلب
      final response = await request.send();

      if (response.statusCode == 200) {
        // معالجة الرد من السيرفر
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);

        if (data['data'] != null) {
          // حفظ البيانات المحدثة في TokenManager
          await TokenManager.saveUserData(data['data']);
        }

        return true; // التحديث تم بنجاح
      } else {
        // في حالة وجود خطأ
        final errorResponse = await response.stream.bytesToString();
        print('Error response: $errorResponse');
        throw Exception(
            'Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error occurred: $e');
    }
  }
}

class FavService {
  final String baseUrl =
      "http://127.0.0.1:8000/api"; // ضع رابط API الخاص بك هنا

  // استرجاع المنتجات المفضلة من الباك إ
  // إضافة منتج إلى المفضلة
  Future<void> addToFavorites(int productId) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/addToFavorites/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to add to favorites');
    }
  }

  // إزالة منتج من المفضلة
  Future<void> removeFromFavorites(int productId) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/deleteFavorite/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    }
  }

  // إزالة جميع المنتجات من المفضلة
  Future<void> removeAllFavorites() async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/deleteAllFavorites'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove all favorites');
    }
  }
}
