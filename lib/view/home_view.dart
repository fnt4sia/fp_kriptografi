import 'package:flutter/material.dart';
import 'package:fp_kriptografi/controller/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: const Color(0xffD0E8C5),
      appBar: AppBar(
        title: const Text(
          "Kripto F nya Fitra",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              controller.logOut();
            },
            color: Colors.white,
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: Obx(
          () => ListView.builder(
            itemCount: controller.listAccount.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(
                    controller.listAccount[index]['username'][0],
                  ),
                ),
                title: Text(controller.listAccount[index]['username']),
                subtitle: Text(controller.listAccount[index]['lastMessage']),
                onTap: () {
                  controller.goToChat(
                    controller.listAccount[index]['username'],
                    controller.listAccount[index]['chatId'],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
