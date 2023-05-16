import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';

class MainController extends GetxController {
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    auth.authStateChanges().listen(
      (event) {
        if (event?.uid != null && event!.uid.isNotEmpty) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.toNamed(Routes.LOGIN);
        }
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
