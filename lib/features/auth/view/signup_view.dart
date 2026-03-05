// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print, deprecated_member_use, unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/features/auth/widgets/custom__auth_buttom.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_snack_bar_error.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_textfield.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  AuthRepo authRepo = AuthRepo();

  bool isLoading = false;

  Future<void> signup() async {
    if (_formkey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final user = await authRepo.signup(
          nameController.text.trim(),
          emailController.text.trim(),
          passController.text.trim(),
        );
        if (user != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Root()));
        }
        setState(() => isLoading = false);
      } catch (e) {
        String errMsg = 'unhandled error in signup';
        if (e is ApiError) errMsg = e.message;
        ScaffoldMessenger.of(context).showSnackBar(customSnackBarError(errMsg));
      } finally {
        setState(() => isLoading = false);
      }
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
                              text: "Welcome to our Food App",
                              size: 13,
                              weight: FontWeight.w500,
                            ),
                            const Gap(100),

                            // اللوح الرمادي
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 198, 198, 198),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Gap(40),

                                  // الحقول
                                  CustomTextfield(
                                    hint: "Name",
                                    ispassword: false,
                                    controller: nameController,
                                  ),
                                  const Gap(12),

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

                                  // زر Sign up أخضر ممتلئ
                                  isLoading
                                      ? CupertinoActivityIndicator()
                                      : CustomAuthButtom(
                                          text: "Sign up",
                                          color: AppColors.primary,
                                          textcolor: Colors.white,
                                          borderColor: AppColors.primary,
                                          ontap: signup,
                                        ),

                                  const Gap(10),

                                  // زرّان جنب بعض: Login و Guest
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomAuthButtom(
                                          text: "Login",
                                          color: Colors.white,
                                          textcolor: AppColors.primary,
                                          borderColor: AppColors.primary,
                                          ontap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const LoginView(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Gap(10),
                                      Expanded(
                                        child: CustomAuthButtom(
                                          text: "As A Guest",
                                          color: Colors.white,
                                          textcolor: AppColors.primary,
                                          borderColor: AppColors.primary,
                                          ontap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => Root(),
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
                              color: AppColors.primary,
                              weight: FontWeight.bold,
                              align: TextAlign.center,
                            ),
                            Gap(10),
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
