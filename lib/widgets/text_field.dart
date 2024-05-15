import 'package:flutter/material.dart';

TextField reusableTextField({
  required IconData icon,
  required String text,
  required bool isPassword,
  required TextEditingController controller,
  required TextInputType keyboard,
  required bool readText,
}) {
  return TextField(
      controller: controller,
      readOnly: readText,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        labelText: text,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 18,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: keyboard);
}
