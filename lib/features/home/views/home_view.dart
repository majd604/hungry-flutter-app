// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/home/data/models/product_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';

import 'package:hungry/features/home/widgets/card_iteams.dart';
import 'package:hungry/features/home/widgets/food_category.dart';
import 'package:hungry/features/home/widgets/search_field.dart';
import 'package:hungry/features/home/widgets/user_header.dart';
import 'package:hungry/features/prodect/views/prodect_details_views.dart';
import 'package:hungry/shared/custom_snack_bar_error.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> category = [
    "All",
    "Combos",
    "Sliders",
    "Classic",
    "Specy",
  ];
  int selectedIndex = 0;
  final TextEditingController controller = TextEditingController();
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

  List<ProductModel>? prodects;
  List<ProductModel>? allProduct;
  final ProductRepo productRepo = ProductRepo();

  Future<void> getProdects() async {
    final res = await productRepo.getProdects();
    if (!mounted) return;
    setState(() {
      allProduct = res;
      prodects = res;
    });
  }

  @override
  void initState() {
    getProfileData();
    getProdects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Skeletonizer(
        enabled: prodects == null,
        child: Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // AppBar
              SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: 170,
                automaticallyImplyLeading: false,
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(16),
                        UserHeader(
                          userName: userModel?.name ?? " As A Guest",
                          userImage:
                              userModel?.image ??
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmwCmC6pZjmJZsvvNufFvqxJf7_C73ff3_Bg&s",
                        ),
                        Gap(16),
                        SearchField(
                          controller: controller,
                          onChanged: (value) {
                            final query = value.toLowerCase();
                            setState(() {
                              prodects = allProduct
                                  ?.where(
                                    (p) => p.name.toLowerCase().contains(query),
                                  )
                                  .toList();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // FoodCategory
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: FoodCategory(
                    category: category,
                    selectedIndex: selectedIndex,
                  ),
                ),
              ),

              // GridView
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.74,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final prodect = prodects![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProdectDetailsViews(product: prodect),
                          ),
                        );
                      },
                      child: CardIteams(
                        text: prodect.name,
                        rate: prodect.rate,
                        desc: prodect.desc,
                        image: prodect.image,
                      ),
                    );
                  }, childCount: prodects?.length ?? 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
