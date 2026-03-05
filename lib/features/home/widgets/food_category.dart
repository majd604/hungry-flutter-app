// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class FoodCategory extends StatefulWidget {
  FoodCategory({
    super.key,
    required this.category,
    required this.selectedIndex,
  });
  final List category;
  final selectedIndex;

  @override
  State<FoodCategory> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.category.length, (index) {
          final bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 15),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomText(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                text: widget.category[index],
                weight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }
}
