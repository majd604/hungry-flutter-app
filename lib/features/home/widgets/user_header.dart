// ignore_for_file: deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    required this.userImage,
    required this.userName,
  });
  final String userName, userImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // النصوص على اليسار
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "Hello,$userName",
                color: Colors.black.withOpacity(0.90),
                weight: FontWeight.w600,
                size: 24,
              ),
              const Gap(4),
              CustomText(
                text: "Hungry Today?",
                color: Colors.black.withOpacity(0.4),
                weight: FontWeight.w400,
                size: 13,
              ),
            ],
          ),
        ),
        const Gap(12),
        // صورة البروفايل
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: Image.network(
              userImage,
              width: 80,
              height: 80,

              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
            ),
          ),
        ),
      ],
    );
  }
}
