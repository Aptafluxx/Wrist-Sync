import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends GetxService {
  AppSettingsService(ThemeMode initialThemeMode)
    : themeMode = initialThemeMode.obs;

  final Rx<ThemeMode> themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('themeMode', mode.name);
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }
}
