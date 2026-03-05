// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomUserTxtFiled extends StatelessWidget {
  CustomUserTxtFiled({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.color,
    required TextInputType textInputType,
  });
  final TextEditingController controller;
  final String label;
  Color? color;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: Colors.black,
      cursorHeight: 20,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        labelText: label,
        labelStyle: TextStyle(
          color: color ?? Color.fromARGB(255, 23, 23, 22),
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: color ?? Color.fromARGB(255, 162, 162, 161),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: color ?? Color.fromARGB(255, 23, 23, 22),
          ),
        ),
      ),
    );
  }
}
