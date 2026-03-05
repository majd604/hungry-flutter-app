// ignore_for_file: body_might_complete_normally_nullable, no_leading_underscores_for_local_identifiers, avoid_print, deprecated_member_use, unnecessary_null_comparison, use_build_context_synchronously, unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/view/signup_view.dart';
import 'package:hungry/features/auth/widgets/custom__auth_buttom.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_snack_bar_error.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController.text = "majd@gmail.com";
    passController.text = "12345678";
    super.initState();
  }

  bool isLoading = false;
  final AuthRepo authRepo = AuthRepo();

  Future<void> login() async {
    // لا نشغّل اللودينغ إن كان الفالديشن فاشل
    if (!_formkey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final user = await authRepo.login(
        emailController.text.trim(),
        passController.text.trim(),
      );
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (c) => Root()));
      }
    } catch (e) {
      String errorMsg = 'unhandled error in login';
      if (e is ApiError) errorMsg = e.message;

      ScaffoldMessenger.of(context).showSnackBar(customSnackBarError(errorMsg));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Gap(70),
                            // الشعار
                            SvgPicture.asset(
                              'assets/logo/logo.svg',
                              color: AppColors.primary,
                              height: 48,
                            ),
                            const Gap(8),
                            const CustomText(
                              text: "Welcome Back, Discover The Fast Food",
                              size: 13,
                              weight: FontWeight.w500,
                            ),

                            const Gap(100),

                            // اللوح الرمادي مع الحقول والأزرار
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  198,
                                  198,
                                  198,
                                ), // رمادي فاتح
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Gap(30),
                                  CustomTextfield(
                                    hint: "Email Address",
                                    ispassword: false,
                                    controller: emailController,
                                  ),
                                  const Gap(12),
                                  CustomTextfield(
                                    hint: "Password",
                                    ispassword: true,
                                    controller: passController,
                                  ),
                                  const Gap(16),

                                  // زر Login أخضر ممتلئ
                                  isLoading
                                      ? const SizedBox(
                                          height: 48,
                                          child: Center(
                                            child: CupertinoActivityIndicator(
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : CustomAuthButtom(
                                          text: "Login",
                                          color: AppColors.primary,
                                          textcolor: Colors.white,
                                          borderColor: AppColors.primary,
                                          ontap: login,
                                        ),
                                  const Gap(10),

                                  // Signup (أبيض بحدّ أخضر)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomAuthButtom(
                                          text: "Signup",
                                          color: Colors.white,
                                          textcolor: AppColors.primary,
                                          borderColor: AppColors.primary,
                                          ontap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (c) =>
                                                    const SignupView(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: CustomAuthButtom(
                                          text: "As A Guest",
                                          color: Colors.white,
                                          textcolor: AppColors.primary,
                                          borderColor: AppColors.primary,
                                          ontap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (c) => Root(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Gap(20),
                                ],
                              ),
                            ),

                            const Spacer(),
                            CustomText(
                              text: "Hungry App © 2024",
                              size: 12,
                              align: TextAlign.center,
                              color: AppColors.primary,
                              weight: FontWeight.w500,
                            ),
                            Gap(20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
