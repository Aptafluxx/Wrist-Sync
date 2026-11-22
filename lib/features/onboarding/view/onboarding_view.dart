import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/core/widgets/app_button.dart';
import 'package:wrist_sync/features/onboarding/controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
        child: Container(
          decoration: const BoxDecoration(gradient: HomeDesign.heroGradient),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: HomeDesign.cyan.withValues(alpha: 0.32),
                        ),
                      ),
                      child: const Icon(
                        Icons.watch_rounded,
                        size: 64,
                        color: HomeDesign.cyan,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Connect seamlessly',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pair your smartwatch via Bluetooth and keep your connection status close at hand.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFD4E2EB),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 36),
                    AppButton(
                      text: 'Get started',
                      onPressed: controller.completeOnboarding,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
