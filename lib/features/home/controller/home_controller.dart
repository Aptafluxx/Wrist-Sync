import 'package:get/get.dart';
import 'package:wrist_sync/routes/app_routes.dart';

class HomeController extends GetxController {
  void navigateToSelection() {
    Get.toNamed(AppRoutes.selection);
  }

  void navigateToMyWatches() {
    Get.toNamed(AppRoutes.myWatches);
  }

  void navigateToWatchFaces() {
    Get.toNamed(AppRoutes.watchFaces);
  }

  void navigateToHelp() {
    Get.toNamed(AppRoutes.help);
  }
}
