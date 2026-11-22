import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wrist_sync/core/theme/app_theme.dart';
import 'package:wrist_sync/features/home/controller/home_controller.dart';
import 'package:wrist_sync/features/home/view/home_view.dart';
import 'package:wrist_sync/features/home/widgets/hero_card.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('home screen fits a narrow phone in $brightness mode', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 740);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      Get.put(HomeController());
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: const HomeView(),
            ),
          ),
        ),
      );
      final initialHeroFade = tester.widget<FadeTransition>(
        find
            .ancestor(
              of: find.byType(HeroCard),
              matching: find.byType(FadeTransition),
            )
            .first,
      );
      expect(initialHeroFade.opacity.value, greaterThan(0));
      await tester.pumpAndSettle();

      expect(find.text('No watch connected'), findsOneWidget);
      expect(find.text('Featured watch faces'), findsOneWidget);
      expect(find.text('Health & Battery Sync'), findsOneWidget);

      final heroFade = tester.widget<FadeTransition>(
        find
            .ancestor(
              of: find.byType(HeroCard),
              matching: find.byType(FadeTransition),
            )
            .first,
      );
      expect(heroFade.opacity.value, 1);

      final screenWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final heroRect = tester.getRect(find.byType(HeroCard));
      expect(heroRect.left, greaterThanOrEqualTo(0));
      expect(heroRect.top, greaterThanOrEqualTo(0));
      expect(heroRect.right, lessThanOrEqualTo(screenWidth));
      expect(heroRect.bottom, lessThanOrEqualTo(screenHeight));
      expect(
        tester
            .getRect(find.byKey(const ValueKey('home-bottom-nav-pill')))
            .bottom,
        closeTo(screenHeight - 10, 1),
      );

      final initialLayoutError = tester.takeException();
      expect(initialLayoutError, isNull, reason: '$initialLayoutError');

      await tester.ensureVisible(find.text('Need help connecting?'));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Need help connecting?'), findsOneWidget);
      final scrolledLayoutError = tester.takeException();
      expect(scrolledLayoutError, isNull, reason: '$scrolledLayoutError');

      Get.reset();
    });
  }
}
