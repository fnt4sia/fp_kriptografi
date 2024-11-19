import 'package:flutter/material.dart';
import 'package:fp_kriptografi/shared/utils/login_register_utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final Rx<TextEditingController> usernameController =
      TextEditingController().obs;
  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;
  final isPassword = true.obs;

  @override
  void onInit() async {
    super.onInit();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      Get.offAllNamed('/home');
    }
  }

  Future<void> tryLogin() async {
    String? userId = await LoginRegisterUtils.tryLogin(
      usernameController.value.text,
      passwordController.value.text,
    );

    if (userId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userId);
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        'Login Failed',
        'Username or Password is wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void goToRegister() {
    Get.toNamed('/register');
  }
}
