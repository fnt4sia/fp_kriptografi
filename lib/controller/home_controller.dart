import 'package:fp_kriptografi/shared/utils/user_utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> listAccount = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccount();
  }

  void goToChat(String username, String chatId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String currentId = prefs.getString('userId') ?? '';
    Get.delete<HomeController>();
    Get.offNamed(
      '/chat',
      arguments: {
        'currentId': currentId,
        'username': username,
        'chatId': chatId,
      },
    );
  }

  Future<void> fetchAccount() async {
    try {
      listAccount.value = await UserUtils.fetchAccountsAndLastMessages();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch account data',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> logOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to log out',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
