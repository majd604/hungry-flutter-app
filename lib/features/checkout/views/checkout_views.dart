import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/checkout/widgets/order_details_widget.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_snack_bar_error.dart';
import 'package:hungry/shared/custom_text.dart';

class CheckoutViews extends StatefulWidget {
  const CheckoutViews({super.key, required this.totalPrice});
  final String totalPrice;

  @override
  State<CheckoutViews> createState() => _CheckoutViewsState();
}

class _CheckoutViewsState extends State<CheckoutViews> {
  String isSelected = 'Cash';

  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;

  //get Profile Data
  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      if (!mounted) return;
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String errorMsg = "Error In Fetching Profile Data";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(customSnackBarError(errorMsg));
    }
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Order summary",
                size: 25,
                weight: FontWeight.w600,
              ),
              Gap(20),
              OrderDetailsWidget(
                order: widget.totalPrice,
                taxes: "0.3",
                fees: "1.3",
                total: (double.parse(widget.totalPrice) + 0.3 + 1.3)
                    .toStringAsFixed(2),
              ),
              Gap(60),
              CustomText(
                text: "Payment methods",
                size: 25,
                weight: FontWeight.w600,
              ),
              Gap(30),
              //Cash
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(13),
                ),
                tileColor: Color(0xff3C2F2F),
                title: CustomText(
                  text: "Cash On Delevery",
                  color: Colors.white,
                ),
                leading: Image.asset("assets/icon/cash.png"),
                trailing: Radio<String>(
                  activeColor: Colors.white,
                  groupValue: isSelected,
                  value: "Cash",
                  onChanged: (value) {
                    setState(() => isSelected = value!);
                  },
                ),
                onTap: () => setState(() => isSelected = "Cash"),
              ),

              Gap(20),
              //Visa
              userModel?.visa == null
                  ? SizedBox()
                  : ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(13),
                      ),
                      tileColor: Colors.blue.shade900,

                      title: CustomText(
                        text: "Debit Card",
                        color: Colors.white,
                      ),
                      subtitle: CustomText(
                        text: userModel?.visa ?? "3566 **** **** 0505",
                        color: Colors.white,
                      ),
                      leading: Image.asset(
                        "assets/icon/visa.png",
                        color: Colors.white,
                      ),
                      trailing: Radio<String>(
                        activeColor: Colors.white,
                        groupValue: isSelected,
                        value: "Visa",
                        onChanged: (value) {
                          setState(() => isSelected = value!);
                        },
                      ),
                      onTap: () => setState(() => isSelected = "Visa"),
                    ),

              Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Color(0xffEF2A39),
                      value: true,
                      onChanged: (v) {},
                    ),
                    Flexible(
                      child: CustomText(
                        text: "Save card details for future payments",
                      ),
                    ),
                  ],
                ),
              ),
              Gap(170),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.only(top: 10),
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.grey.shade800,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CustomText(
                    text: "Total Price:",
                    size: 20,
                    color: Colors.grey,
                  ),
                  CustomText(
                    text:
                        "\$ ${(double.parse(widget.totalPrice) + 0.3 + 1.3).toStringAsFixed(2)}",
                    size: 20,
                  ),
                ],
              ),
              CustomButton(
                text: "Pay Now",
                height: 50,
                width: 180,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (contex) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: 10,
                            vertical: 220,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 15,
                                  color: Colors.grey.shade800,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: AppColors.primary,
                                    child: Icon(
                                      CupertinoIcons.check_mark,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Gap(20),
                                  CustomText(
                                    text: "Success!",
                                    color: AppColors.primary,
                                    size: 30,
                                    weight: FontWeight.bold,
                                  ),
                                  Gap(13),
                                  Center(
                                    child: CustomText(
                                      color: Colors.grey.shade700,
                                      size: 15,
                                      text:
                                          "Your payment was successful.\nA receipt for this purchase has\n been sent to your email.",
                                    ),
                                  ),
                                  Gap(30),
                                  CustomButton(
                                    text: "Close",
                                    onTap: () => Navigator.pop(contex),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
