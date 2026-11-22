import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/services/ble_service.dart';
import 'core/services/app_settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final storedThemeMode = preferences.getString('themeMode');
  final initialThemeMode = ThemeMode.values.firstWhere(
    (mode) => mode.name == storedThemeMode,
    orElse: () => ThemeMode.system,
  );

  Get.put(AppSettingsService(initialThemeMode), permanent: true);
  Get.put(BleService(), permanent: true);

  runApp(
    GetMaterialApp(
      title: 'WristSync',
      theme: AppTheme.appTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: initialThemeMode,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    ),
  );
}
