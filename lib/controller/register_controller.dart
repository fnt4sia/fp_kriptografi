import 'package:flutter/material.dart';
import 'package:fp_kriptografi/shared/utils/login_register_utils.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> usernameController =
      TextEditingController().obs;
  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;

  void goToLogin() {
    Get.toNamed('/login');
  }

  Future<void> createAccount() async {
    bool tryRegister = await LoginRegisterUtils.createAccount(
      emailController.value.text,
      passwordController.value.text,
      usernameController.value.text,
    );

    if (tryRegister) {
      Get.offAllNamed('/login');
    } else {
      Get.snackbar(
        "Error",
        "Failed to create account",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
