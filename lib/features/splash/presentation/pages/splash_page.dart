import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _chartController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<double> _chartSlideAnimation;
  late Animation<double> _chartFadeAnimation;
  late Animation<double> _chartScaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _navigateToOnboarding();
  }

  void _initializeAnimations() {
    _chartController = AnimationController(
      duration: AppConstants.longAnimationDuration,
      vsync: this,
    );

    _chartSlideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.easeOutCubic),
    );

    _chartFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _chartController, curve: Curves.easeIn));

    _chartScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.easeOutBack),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _rotateAnimation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _chartController.forward();
  }

  void _navigateToOnboarding() {
    Timer(AppConstants.splashDuration, () {
      if (mounted) {
        NavigationHelper.pushReplacement(context, const OnboardingPage());
      }
    });
  }

  @override
  void dispose() {
    _chartController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: _buildAnimatedChart(),
        ),
      ),
    );
  }

  Widget _buildAnimatedChart() {
    // حساب حجم الشاشة - Calculate screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // حجم اللوجو يكون 55% من عرض الشاشة
    final logoSize = (screenWidth * 0.55).clamp(200.0, 320.0);
    
    return AnimatedBuilder(
      animation: _chartController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _chartSlideAnimation.value),
          child: Transform.scale(
            scale: _chartScaleAnimation.value,
            child: Opacity(
              opacity: _chartFadeAnimation.value,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateAnimation.value,
                          child: SizedBox(
                            width: logoSize,
                            height: logoSize,
                            child: Image.asset(
                              'assets/images/bluelogosavelet.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
