import 'package:flutter/material.dart';
import 'package:fp_kriptografi/controller/login_controller.dart';
import 'package:fp_kriptografi/shared/widget/custom_text_field.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: const Color(0xffD0E8C5),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome \n Maidenless Tarnished',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  hintText: "Username",
                  iconImage: const Icon(Icons.person_2_outlined),
                  isPassword: false,
                  controller: controller.usernameController.value,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Password",
                  iconImage: const Icon(Icons.lock_outline),
                  isPassword: true,
                  controller: controller.passwordController.value,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    controller.tryLogin();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffD0E8C5),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 75, 135, 45),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 125,
                      height: 1,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 75, 135, 45),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Atau",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 125,
                      height: 1,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 75, 135, 45),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Belum mempunyai akun?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.goToRegister();
                      },
                      child: const Text(
                        " Daftar",
                        style: TextStyle(
                          color: Color.fromARGB(255, 75, 135, 60),
                          fontSize: 17,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
