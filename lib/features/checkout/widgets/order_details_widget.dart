import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({
    super.key,
    required this.order,
    required this.taxes,
    required this.fees,
    required this.total,
  });
  final String order, taxes, fees, total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        checkOut("Order", order, false, false),
        Gap(20),
        checkOut("Taxes", taxes, false, false),
        Gap(20),
        checkOut("Delivery fees", fees, false, false),
        Gap(8),
        Divider(),
        Gap(20),
        checkOut("Total:", total, true, false),
        Gap(15),
        checkOut("Estimated delivery time:", "15 - 30 mins", true, true),
      ],
    );
  }
}

Widget checkOut(title, price, isBold, isSmall) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: title,
        size: isSmall ? 15 : 20,
        weight: isBold ? FontWeight.bold : FontWeight.w400,
        color: isBold ? Colors.black : Colors.grey.shade400,
      ),
      CustomText(
        text: '$price \$',
        size: isSmall ? 15 : 20,
        weight: isBold ? FontWeight.bold : FontWeight.w400,
        color: isBold ? Colors.black : Colors.grey.shade400,
      ),
    ],
  );
}
