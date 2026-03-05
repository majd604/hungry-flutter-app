import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.color,
    this.height,
    this.textcolor,
    this.gap,
    this.widget,
  });
  final String text;
  final Function()? onTap;
  final double? width;
  final Color? color;
  final double? height;
  final Color? textcolor;
  final double? gap;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color ?? AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: text,
              color: textcolor ?? Colors.white,
              size: 14,
              weight: FontWeight.w500,
            ),
            Gap(gap ?? 0.0),
            widget ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
