import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.size,
    this.weight,
    this.align,
    this.maxLines,
  });

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines ?? 2,
      overflow: TextOverflow.ellipsis,
      textScaler: const TextScaler.linear(1.0),
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: size ?? 16,
        fontWeight: weight,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
