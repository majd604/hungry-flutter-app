// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unused_local_variable, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/features/auth/widgets/custom_user_txt_filed.dart';
import 'package:hungry/shared/custom_snack_bar.dart';
import 'package:hungry/shared/custom_snack_bar_error.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();
  UserModel? userModel;
  String? selectedImage;
  bool isLoading = false;
  bool isLoadingLogout = false;
  bool isGuest = false;
  AuthRepo authRepo = AuthRepo();

  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    if (!mounted) return;
    setState(() => isGuest = authRepo.isGuest);
    if (user != null) {
      setState(() => userModel = user);
    }
  }

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

  //Pick Image
  Future<void> pikeImage() async {
    final pikedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pikedImage != null) {
      setState(() {
        selectedImage = pikedImage.path;
      });
    }
  }

  //update Profile
  Future<void> updateProfile() async {
    try {
      setState(() => isLoading = true);
      final user = await authRepo.updateProfile(
        name: _name.text.trim(),
        email: _email.text.trim(),
        address: _address.text.trim(),
        imagePath: selectedImage ?? "",
        visa: _visa.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnackBar("Profile Updated Successfully"));

      setState(() {
        isLoading = false;
        userModel = user;
      });
      await getProfileData();
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      String errorMsg = "Error In Update Profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnackBarError(errorMsg));
    }
  }

  Future<void> logout() async {
    try {
      setState(() => isLoadingLogout = true);
      await authRepo.logout();
      if (!mounted) return;
      setState(() => isLoadingLogout = false);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const LoginView();
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingLogout = false);
    }
  }

  @override
  void initState() {
    autoLogin();
    getProfileData().then((v) {
      _name.text = userModel?.name ?? "Knuckles The Echidna";
      _email.text = userModel?.email ?? "Kas***@gmail.com";
      _address.text = userModel?.address ?? "You Dont Have Address Yet";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isGuest) {
      return RefreshIndicator(
        backgroundColor: AppColors.primary,
        color: Colors.white,
        onRefresh: () async {
          await getProfileData();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: const Color(0xfffefefe),
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
              backgroundColor: const Color(0xfffefefe),
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.settings, color: Colors.black, size: 30),
                ),
              ],
            ),
            body: Column(
              children: [
                // الجزء القابل للسكرول
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Skeletonizer(
                        enabled: userModel == null,
                        child: Column(
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  //image
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 1,
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: selectedImage != null
                                        ? Image.file(
                                            File(selectedImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : (userModel?.image != null &&
                                              userModel!.image!.isNotEmpty)
                                        ? Image.network(
                                            userModel!.image!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, err, builder) =>
                                                    const Icon(Icons.person),
                                          )
                                        : const Icon(Icons.person),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: pikeImage,
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(20),

                            CustomUserTxtFiled(
                              textInputType: TextInputType.name,
                              controller: _name,
                              label: "Name",
                            ),
                            const Gap(20),
                            CustomUserTxtFiled(
                              textInputType: TextInputType.emailAddress,
                              controller: _email,
                              label: "Email",
                            ),
                            const Gap(20),
                            CustomUserTxtFiled(
                              textInputType: TextInputType.none,
                              controller: _address,
                              label: "Address",
                            ),
                            const Gap(20),
                            const Divider(),
                            const Gap(10),
                            userModel?.visa == null
                                ? CustomUserTxtFiled(
                                    controller: _visa,
                                    textInputType: TextInputType.number,
                                    label: 'add VISA CARD',
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade900,
                                          Colors.blue.shade900,
                                          Colors.blue.shade500,
                                          Colors.blue.shade900,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon/visa.png',
                                          width: 45,
                                          color: Colors.white,
                                        ),
                                        Gap(20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: 'Debit Card',
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            CustomText(
                                              text:
                                                  userModel?.visa ??
                                                  "**** **** **** 9857",
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              40,
                                            ),
                                          ),
                                          child: CustomText(
                                            text: 'Default',
                                            color: Colors.grey.shade800,
                                            size: 12,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Gap(8),
                                        Icon(
                                          CupertinoIcons
                                              .check_mark_circled_solid,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                            const Gap(20),
                            Container(
                              height: 70,

                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Edit Profile Button
                                    isLoading
                                        ? CircularProgressIndicator(
                                            color: AppColors.primary,
                                          )
                                        : GestureDetector(
                                            onTap: updateProfile,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 16,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: const [
                                                  CustomText(
                                                    text: "Edit Profile",
                                                    color: Colors.white,
                                                    size: 15,
                                                    weight: FontWeight.w500,
                                                  ),
                                                  Gap(10),
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    //Logout Button
                                    isLoadingLogout
                                        ? CircularProgressIndicator(
                                            color: AppColors.primary,
                                          )
                                        : GestureDetector(
                                            onTap: logout,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 35,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: const [
                                                  CustomText(
                                                    text: "Logout",
                                                    color: Colors.black,
                                                    size: 15,
                                                    weight: FontWeight.w500,
                                                  ),
                                                  Gap(10),
                                                  Icon(
                                                    Icons.exit_to_app_rounded,
                                                    color: Colors.black,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // الأزرار تحت بدل bottomSheet
              ],
            ),
          ),
        ),
      );
    } else if (isGuest) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                text: "You Are Using Guest Account",
                size: 20,
                weight: FontWeight.bold,
              ),
              const Gap(20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginView();
                      },
                    ),
                  );
                },
                child: const CustomText(
                  text: "Login / Register",
                  color: Colors.white,
                  size: 16,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
