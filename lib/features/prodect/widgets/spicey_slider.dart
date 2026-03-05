import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class SpiceySlider extends StatelessWidget {
  const SpiceySlider({super.key, required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  String get _label {
    if (value <= 0.2) return "Mild";
    if (value <= 0.6) return "Medium";
    return "Hot";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: "Spice level",
              size: 15,
              weight: FontWeight.w600,
            ),
            CustomText(
              text: _label,
              size: 13,
              color: AppColors.primary,
              weight: FontWeight.w600,
            ),
          ],
        ),
        const Gap(8),
        Slider(
          max: 1,
          min: 0,
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          inactiveColor: Colors.grey.shade300,
        ),
        const Gap(4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CustomText(text: '❄️', size: 16),
            CustomText(text: '🌶️', size: 16),
          ],
        ),
      ],
    );
  }
}
