// ignore_for_file: must_be_immutable, sized_box_for_whitespace, deprecated_member_use, use_build_context_synchronously, unused_catch_stack

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/cart/widgets/add_to_cart_error_dialog.dart';
import 'package:hungry/features/cart/widgets/add_to_cart_success_dialog.dart';
import 'package:hungry/features/home/data/models/product_model.dart';
import 'package:hungry/features/home/data/models/toppings_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/features/prodect/widgets/spicey_slider.dart';
import 'package:hungry/features/prodect/widgets/tropping_card.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_snack_bar_error.dart';
import 'package:hungry/shared/custom_text.dart';

class ProdectDetailsViews extends StatefulWidget {
  const ProdectDetailsViews({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProdectDetailsViews> createState() => _ProdectDetailsViewsState();
}

class _ProdectDetailsViewsState extends State<ProdectDetailsViews> {
  double spiceValue = 0.1;

  final int toppingsCount = 5;
  final int sideOptionsCount = 5;
  bool isLoading = false;

  List<ToppingsModel>? toppings;
  List<ToppingsModel>? options;

  // هون رح نخزّن IDs مو index
  final List<int> selectedToppings = [];
  final List<int> selectedSides = [];

  //Prodect Functions
  ProductRepo productRepo = ProductRepo();
  Future<void> getToppong() async {
    final res = await productRepo.gettoppings();
    if (!mounted) return;
    setState(() {
      toppings = res;
    });
  }

  Future<void> getOptions() async {
    final res = await productRepo.getOptions();
    if (!mounted) return;
    setState(() {
      options = res;
    });
  }

  //Cart Functions
  CartRepo cartRepo = CartRepo();

  @override
  void initState() {
    super.initState();
    getToppong();
    getOptions();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_sharp),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج الكبيرة
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary.withOpacity(0.08), Colors.white],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.fastfood, size: 60),
                        ),
                      ),
                    ),
                    const Gap(8),
                  ],
                ),
              ),
            ),

            const Gap(10),

            // الاسم + الريت + السعر
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: product.name,
                        size: 18,
                        weight: FontWeight.w700,
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const Gap(4),
                          CustomText(
                            text: product.rate,
                            size: 14,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: "\$${product.price}",
                      size: 20,
                      weight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    const Gap(5),
                    CustomText(
                      text: "per item",
                      size: 12,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ],
            ),

            const Gap(12),

            // الوصف
            CustomText(
              text: product.desc,
              size: 14,
              color: Colors.grey.shade800,
              maxLines: 5,
              align: TextAlign.left,
            ),

            const Gap(24),

            // كارت السباسي
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(22),
              ),
              child: SpiceySlider(
                value: spiceValue,
                onChanged: (v) => setState(() => spiceValue = v),
              ),
            ),

            const Gap(28),

            // Toppings
            const CustomText(text: "Toppings :", size: 20),
            const Gap(14),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: (toppings == null || toppings!.isEmpty)
                    ? List.generate(toppingsCount, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        );
                      })
                    : List.generate(toppings!.length, (index) {
                        final topping = toppings![index];

                        // ✅ نستخدم ID بدل index
                        final int toppingId = topping.id;
                        final bool isSelected = selectedToppings.contains(
                          toppingId,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: TroppingCard(
                            title: topping.name,
                            assetPath: topping.image,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedToppings.remove(toppingId);
                                } else {
                                  selectedToppings.add(toppingId);
                                }
                              });
                            },
                          ),
                        );
                      }),
              ),
            ),

            const Gap(28),

            // Side options
            const CustomText(text: "Side options :", size: 20),
            const Gap(14),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: (options == null || options!.isEmpty)
                    ? List.generate(sideOptionsCount, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        );
                      })
                    : List.generate(options!.length, (index) {
                        final option = options![index];

                        // ✅ كمان هون نستخدم الـ ID
                        final int optionId = option.id;
                        final bool isSelected = selectedSides.contains(
                          optionId,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: TroppingCard(
                            title: option.name,
                            assetPath: option.image,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSides.remove(optionId);
                                } else {
                                  selectedSides.add(optionId);
                                }
                              });
                            },
                          ),
                        );
                      }),
              ),
            ),

            const Gap(140), // مساحة عشان ما يغطي الـ bottomSheet المحتوى
          ],
        ),
      ),

      // Bottom Sheet
      bottomSheet: Container(
        padding: const EdgeInsets.only(top: 10),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.grey.shade800,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Total :",
                    size: 25,
                    color: Colors.white,
                  ),
                  CustomText(
                    text: "\$${product.price}",
                    size: 22,
                    color: Colors.white,
                  ),
                ],
              ),
              CustomButton(
                widget: isLoading
                    ? const CupertinoActivityIndicator()
                    : const Icon(CupertinoIcons.cart_badge_plus),
                gap: 15,
                text: "Add To Card",
                textcolor: AppColors.primary,
                color: Colors.white,
                onTap: () async {
                  if (isLoading) return; // حماية من الضغط المتكرر

                  try {
                    setState(() => isLoading = true);

                    final cartItem = CartModel(
                      productId: product.id,
                      qty: 1,
                      spicy: spiceValue,
                      // ✅ هلا هدول صاروا IDs حقيقية
                      toppings: List<int>.from(selectedToppings),
                      options: List<int>.from(selectedSides),
                    );

                    await cartRepo.addToCart(
                      CartRequestModel(items: [cartItem]),
                    );

                    if (!mounted) return;
                    setState(() => isLoading = false);

                    // ✅ أنيميشن النجاح
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "cart_success",
                      barrierColor: Colors.black.withOpacity(0.45),
                      transitionDuration: const Duration(milliseconds: 220),
                      pageBuilder: (_, __, ___) {
                        return AddToCartSuccessDialog(
                          message: "Your item has been added to cart",
                        );
                      },
                      transitionBuilder: (_, anim, __, child) {
                        final curved = CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOut,
                        );
                        return Opacity(
                          opacity: curved.value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - curved.value) * 30),
                            child: child,
                          ),
                        );
                      },
                    );
                  } on ApiError catch (e) {
                    if (!mounted) return;
                    setState(() => isLoading = false);

                    String msg = e.message;
                    if (msg.toLowerCase().contains('email already exists')) {
                      msg = 'Something went wrong while adding item to cart';
                    }

                    // 🔴 دايلوج خطأ
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "cart_error",
                      barrierColor: Colors.black.withOpacity(0.45),
                      transitionDuration: const Duration(milliseconds: 220),
                      pageBuilder: (_, __, ___) {
                        return AddToCartErrorDialog(message: msg);
                      },
                      transitionBuilder: (_, anim, __, child) {
                        final curved = CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOut,
                        );
                        return Opacity(
                          opacity: curved.value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - curved.value) * 30),
                            child: child,
                          ),
                        );
                      },
                    );
                  } catch (_) {
                    if (!mounted) return;
                    setState(() => isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBarError("Unexpected error, please try again"),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
