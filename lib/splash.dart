// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/root.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoScale;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _burgerSlide;
  AuthRepo authRepo = AuthRepo();
  Future<void> _checkLogin() async {
    try {
      final user = authRepo.autoLogin();

      if (!mounted) return;
      if (authRepo.isGuest) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Root()),
        );
      } else if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Root()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginView()),
        );
      }
    } catch (e) {
      print("Erro From Splach: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 1.0, curve: Curves.easeOut),
    );

    _burgerSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.45, 1.0, curve: Curves.easeOutBack),
          ),
        );

    // Start animations after first frame for a smoother start.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    // Navigate after a brief moment on the completed splash.
    Future.delayed(const Duration(seconds: 2), _checkLogin);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Center content: logo + tagline
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 180),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: SvgPicture.asset('assets/logo/logo.svg'),
                  ),
                  const Gap(16),
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Text(
                      "Good food. Great mood.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Burger image pinned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _burgerSlide,
              child: Image.asset(
                "assets/splash/splash.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover, // ensures it hugs bottom edge
              ),
            ),
          ),
        ],
      ),
    );
  }
}
