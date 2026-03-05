// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.onChanged, required this.controller});
  final Function(String)? onChanged;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.05),
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 44,
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          cursorColor: Colors.grey.shade700,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search..",
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            filled: true,
            fillColor: const Color(0xfff1f3f4), // رمادي فاتح ناعم
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 18,
              color: Colors.grey.shade500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
