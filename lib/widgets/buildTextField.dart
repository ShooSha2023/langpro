import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField({
  TextEditingController? controller,
  required String label,
  required String hintText,
  required IconData icon,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  String? initialValue,
  Function(dynamic value)? onChanged,
  bool? enabled, // تعديل الـ onChanged ليكون غير فارغ
}) {
  // إذا كان الـ controller فارغًا، قم بإنشاء واحد مع القيمة الأولية.
  controller ??= TextEditingController(text: initialValue);

  return TextField(
    controller: controller,
    enabled: enabled,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    style: TextStyle(color: Color(0xFFEF6C00)),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.orange[800]),
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.orange),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.orange),
      ),
    ),
    onChanged: onChanged, // لا تنسى استخدام onChanged إذا كنت تحتاجه
  );
}
