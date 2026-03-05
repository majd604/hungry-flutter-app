// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class AddToCartErrorDialog extends StatefulWidget {
  final String message;
  const AddToCartErrorDialog({super.key, required this.message});

  @override
  State<AddToCartErrorDialog> createState() => _AddToCartErrorDialogState();
}

class _AddToCartErrorDialogState extends State<AddToCartErrorDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffffebee),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                    size: 34,
                  ),
                ),
                const Gap(16),
                const CustomText(
                  text: "Error",
                  size: 20,
                  weight: FontWeight.w700,
                ),
                const Gap(8),
                CustomText(
                  text: widget.message,
                  size: 14,
                  color: Colors.black87,
                  align: TextAlign.center,
                  maxLines: 3,
                ),
                const Gap(18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const CustomText(
                      text: "OK",
                      color: Colors.white,
                      size: 15,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
