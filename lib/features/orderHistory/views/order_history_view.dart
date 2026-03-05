import 'package:flutter/material.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 20, top: 20),
          physics: BouncingScrollPhysics(),
          itemCount: 7,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/test/order.png", width: 150),
                        Column(
                          children: [
                            CustomText(
                              text: "Hamburger",
                              weight: FontWeight.bold,
                            ),
                            CustomText(text: "Qty:X3"),
                            CustomText(
                              text: "Price:20\$",
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomButton(
                      text: "Re Order",
                      color: Colors.grey,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
