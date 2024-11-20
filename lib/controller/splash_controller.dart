import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      checkUserLoggedIn();
    });
  }

  void checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
