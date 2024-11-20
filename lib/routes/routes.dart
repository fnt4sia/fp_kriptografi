import 'package:fp_kriptografi/view/chat_view.dart';
import 'package:fp_kriptografi/view/home_view.dart';
import 'package:fp_kriptografi/view/login_view.dart';
import 'package:fp_kriptografi/view/register_view.dart';
import 'package:fp_kriptografi/view/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
    ),
    GetPage(
      name: '/register',
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomePage(),
    ),
    GetPage(
      name: '/chat',
      page: () => const ChatPage(),
    ),
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
    ),
  ];
}
