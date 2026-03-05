// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomAuthButtom extends StatelessWidget {
  const CustomAuthButtom({
    super.key,
    required this.text,
    this.ontap,
    this.color,
    this.textcolor,
    this.borderColor,
  });

  final String text;
  final Function()? ontap;
  final Color? color;
  final Color? textcolor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        // لا نحدد width أبداً داخل Row. نخليه يأخذ عرضه من الأب (Expanded/Constrained).
        height: 48,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor ?? Colors.white, width: 1.2),
        ),
        child: Center(
          child: CustomText(
            text: text,
            size: 15,
            weight: FontWeight.w700,
            color: textcolor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
