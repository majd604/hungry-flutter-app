// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class TroppingCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  const TroppingCard({
    super.key,
    required this.title,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : Color(0xffe2e6e5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 55,
                  child: Center(
                    child: Image.network(assetPath, fit: BoxFit.contain),
                  ),
                ),
                const Gap(8),
                CustomText(
                  text: title,
                  color: isSelected ? Colors.white : Colors.black,
                  size: 15,
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),

            // دائرة صغيرة فيها صح لما يكون مختار
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(Icons.check, size: 14, color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
