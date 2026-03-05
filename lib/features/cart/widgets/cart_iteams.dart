// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/shared/custom_text.dart';

class CartIteams extends StatelessWidget {
  const CartIteams({
    super.key,
    required this.isLoading,
    required this.image,
    required this.text,
    required this.desc,
    required this.number,
    required this.toppings,
    required this.sideOptions,
    this.onAdd,
    this.onMinues,
    this.onRemove,
  });

  final bool isLoading;
  final String image, text, desc;
  final int number;
  final List<CartOptionItem> toppings;
  final List<CartOptionItem> sideOptions;
  final Function()? onAdd;
  final Function()? onMinues;
  final Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة البرغر
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.fastfood, size: 40),
              ),
            ),
            const Gap(12),

            // النصوص + التوبينغ + السايد أوبشن
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: text,
                    size: 15,
                    weight: FontWeight.w600,
                    maxLines: 2,
                    align: TextAlign.left,
                  ),
                  const Gap(2),
                  CustomText(
                    text: desc,
                    size: 12,
                    color: Colors.grey.shade600,
                    maxLines: 1,
                    align: TextAlign.left,
                  ),
                  const Gap(8),

                  // Toppings
                  if (toppings.isNotEmpty) ...[
                    CustomText(
                      text: "Toppings",
                      size: 11,
                      weight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                    const Gap(4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: toppings
                          .map((t) => _OptionChip(name: t.name, image: t.image))
                          .toList(),
                    ),
                    const Gap(6),
                  ],

                  // Sides
                  if (sideOptions.isNotEmpty) ...[
                    CustomText(
                      text: "Sides",
                      size: 11,
                      weight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                    const Gap(4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: sideOptions
                          .map((s) => _OptionChip(name: s.name, image: s.image))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),

            const Gap(8),

            // +  العدد  -  و زر Remove
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CircleIconButton(icon: CupertinoIcons.add, onTap: onAdd),
                    const Gap(8),
                    CustomText(
                      text: number.toString(),
                      size: 16,
                      weight: FontWeight.bold,
                    ),
                    const Gap(8),
                    _CircleIconButton(
                      icon: CupertinoIcons.minus,
                      onTap: onMinues,
                    ),
                  ],
                ),
                const Gap(12),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 185, 15, 3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: isLoading
                        ? CupertinoActivityIndicator(color: Colors.white)
                        : Center(
                            child: CustomText(
                              text: "Remove",
                              size: 11,
                              color: Colors.white,
                              weight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.primary,
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 9,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(image),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 4),
          CustomText(text: name, size: 9, color: Colors.grey.shade800),
        ],
      ),
    );
  }
}
