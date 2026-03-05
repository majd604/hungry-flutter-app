// cart_view.dart
// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/cart/widgets/cart_iteams.dart';
import 'package:hungry/features/checkout/views/checkout_views.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_snack_bar_error.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  CartRepo cartRepo = CartRepo();
  GetCartResponse? cartResponse;

  late List<int> quantities = [];
  bool isLoading = false;
  int? removingItemId;
  bool isGuest = false;
  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();

  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    if (!mounted) return;
    setState(() => isGuest = authRepo.isGuest);
    if (user != null) {
      setState(() => userModel = user);
    }
  }

  Future<void> getCartData() async {
    try {
      if (!mounted) return;
      setState(() => isLoading = true);

      final res = await cartRepo.getCardData();

      if (!mounted) return;

      cartResponse = res;

      final items = cartResponse?.cartData.items ?? [];

      quantities = items.isNotEmpty
          ? items.map((e) => e.quantity).toList()
          : [];

      setState(() {
        cartRepo = res as CartRepo;
        isLoading = false;
      });
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnackBarError(e.message));
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnackBarError("Unexpected error, please try again"));
    }
  }

  @override
  void initState() {
    super.initState();
    autoLogin();
    getCartData();
  }

  void onAdd(int index) {
    if (index >= quantities.length) return;
    setState(() {
      quantities[index]++;
    });
  }

  void onMin(int index) {
    if (index >= quantities.length) return;
    setState(() {
      if (quantities[index] > 1) {
        quantities[index]--;
      }
    });
  }

  Future<void> removeCartIteam(int id) async {
    try {
      setState(() => removingItemId = id);

      await cartRepo.removeCartIteams(id);

      if (!mounted) return;
      setState(() => removingItemId = null);

      await getCartData();
    } catch (e) {
      if (!mounted) return;
      setState(() => removingItemId = null);
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = cartResponse?.cartData.items ?? [];

    // لو لسا لودينغ رح نرجّع 6 كروت وهمية للسكلتون
    final int itemCount = items.isEmpty ? 6 : items.length;
    if (!isGuest) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Skeletonizer(
          enabled: isLoading || cartResponse == null,
          child: Column(
            children: [
              // قائمة السلة
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      // أثناء اللودينغ: كارت وهمي شكله نفس الحقيقي
                      if (items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                                vertical: 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 16,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          height: 12,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          height: 12,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final item = items[index];
                      final qty = (index < quantities.length)
                          ? quantities[index]
                          : item.quantity;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: CartIteams(
                          isLoading: removingItemId == item.itemId,
                          image: item.image,
                          text: item.name,
                          desc: "Veggie Burger",
                          number: qty,
                          toppings: item.toppings,
                          sideOptions: item.sideOptions,
                          onAdd: () => onAdd(index),
                          onMinues: () => onMin(index),
                          onRemove: () {
                            removeCartIteam(item.itemId);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Bottom total + checkout
              // بدال SafeArea القديم في cart_view.dart
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: "Total",
                                size: 13,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text:
                                    "\$${cartResponse?.cartData.totalPrice ?? '0.00'}",
                                size: 22,
                                weight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          text: "Check Out",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => CheckoutViews(
                                  totalPrice:
                                      cartResponse?.cartData.totalPrice ??
                                      "0.0",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (isGuest) {
      return Center(child: CustomText(text: "Please LogIn"));
    } else {
      return SizedBox.shrink();
    }
  }
}
