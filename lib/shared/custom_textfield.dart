// ignore_for_file: body_might_complete_normally_nullable, no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hint,
    required this.ispassword,
    required this.controller,
  });

  final String hint;
  final bool ispassword;
  final TextEditingController controller;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.ispassword; // يبدأ مخفي إذا كان باسورد
  }

  void _togglePassword() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);

    OutlineInputBorder _noBorder() => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none, // بدون إطار بشكل طبيعي
    );

    OutlineInputBorder _errorBorder() => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: Colors.red.shade400, width: 1.3),
    );

    return TextFormField(
      controller: widget.controller,
      cursorHeight: 20,
      cursorColor: AppColors.primary,
      obscureText: widget.ispassword ? _obscureText : false,
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          // نفس صياغة الصورة: please fill ...
          return 'please fill ${widget.hint}';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.grey.shade700),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        // لا نُظهر إطار إلا في حالة الخطأ (أحمر)
        enabledBorder: _noBorder(),
        focusedBorder: _noBorder(),
        errorBorder: _errorBorder(),
        focusedErrorBorder: _errorBorder(),

        // نص الخطأ صغير وتحت مثل التصميم
        errorStyle: TextStyle(
          color: Colors.red.shade700,
          fontSize: 11,
          height: 1.1,
        ),

        // أيقونة العين لحقل الباسورد فقط
        suffixIcon: widget.ispassword
            ? IconButton(
                onPressed: _togglePassword,
                icon: Icon(
                  _obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  size: 20,
                  color: Colors.grey.shade700,
                ),
              )
            : null,
      ),
    );
  }
}
