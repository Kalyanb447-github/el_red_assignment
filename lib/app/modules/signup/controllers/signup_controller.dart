import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  //TODO: Implement SignupController

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  signup() async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print(user);

      if (user.user!.uid != null && user.user!.uid.isNotEmpty) {
        Get.offAllNamed(Routes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Something is wrong', e.message.toString());
    } catch (e) {
      Get.snackbar('Something is wrong', e.toString());
    }
  }
}
