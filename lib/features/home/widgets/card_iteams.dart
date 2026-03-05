// ignore_for_file: unnecessary_brace_in_string_interps, use_full_hex_values_for_flutter_colors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class CardIteams extends StatelessWidget {
  const CardIteams({
    super.key,
    required this.text,
    required this.rate,
    required this.desc,
    required this.image,
  });

  final String text, rate, desc, image;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffcbcbcbf), // نفس لون الكارت بالصورة
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة البرغر + الشادو
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -0,
                    child: Image.asset(
                      "assets/icon/shadow.png",
                      color: Color.fromARGB(251, 78, 78, 79),

                      fit: BoxFit.contain,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.network(
                      image,
                      height: 135,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(8),

            // اسم البرغر
            CustomText(
              text: text,
              weight: FontWeight.bold,
              size: 15,
              color: Colors.white,
            ),

            const Gap(3),

            // الوصف القصير
            CustomText(text: desc, size: 13, color: Colors.white),

            const Gap(8),

            // النجمة + التقييم + القلب
            Row(
              children: [
                const Icon(Icons.star, size: 22, color: Colors.white),
                const Gap(6),
                CustomText(
                  text: rate,
                  color: Colors.white,
                  size: 15,
                  weight: FontWeight.w600,
                ),
                const Spacer(),
                const Icon(CupertinoIcons.heart, size: 20, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
