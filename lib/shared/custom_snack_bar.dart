import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

SnackBar customSnackBar(errorMsg) {
  return SnackBar(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
    backgroundColor: Colors.blue.shade800,
    content: Row(
      children: [
        const Icon(Icons.done_outline_rounded, color: Colors.white),
        const Gap(10),
        Expanded(
          child: CustomText(
            text: errorMsg,
            color: Colors.white,
            weight: FontWeight.bold,
            size: 15,
            align: TextAlign.left,
            maxLines: 3,
          ),
        ),
      ],
    ),
  );
}
