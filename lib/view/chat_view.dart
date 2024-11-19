import 'package:flutter/material.dart';
import 'package:fp_kriptografi/controller/chat_controller.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.username.value,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed('/home');
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          Get.offAllNamed('/home');
        },
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.messages.isEmpty) {
                  return const Center(
                    child: Text("No messages yet"),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final isCurrentUser =
                        message['senderId'] == controller.currentUserId;
                    final isImage = message['type'] == 'image';

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Colors.teal.shade100
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(8.0),
                            topRight: const Radius.circular(8.0),
                            bottomLeft: isCurrentUser
                                ? const Radius.circular(8.0)
                                : const Radius.circular(0),
                            bottomRight: isCurrentUser
                                ? const Radius.circular(0)
                                : const Radius.circular(8.0),
                          ),
                        ),
                        child: isImage
                            ? GestureDetector(
                                onTap: () async {
                                  BuildContext dialogContext = context;

                                  String hiddenMessage = '';
                                  if (message['hasMessage']) {
                                    hiddenMessage = await controller
                                        .receiveImage(message['content']);
                                  }

                                  if (!dialogContext.mounted) return;

                                  showDialog(
                                    context: dialogContext,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.network(
                                                message['content'],
                                                fit: BoxFit.contain,
                                              ),
                                              if (message['hasMessage'] &&
                                                  hiddenMessage.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(hiddenMessage),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Image.network(
                                  message['content'],
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                    );
                                  },
                                ),
                              )
                            : Text(
                                message['content'],
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () async {
                      final value = await showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(0, 1000, 0, 0),
                        items: [
                          const PopupMenuItem(
                            value: 'image',
                            child: Row(
                              children: [
                                Icon(Icons.image),
                                SizedBox(width: 10),
                                Text('Image'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'file',
                            child: Row(
                              children: [
                                Icon(Icons.insert_drive_file),
                                SizedBox(width: 10),
                                Text('File'),
                              ],
                            ),
                          ),
                        ],
                      );

                      if (value == 'image') {
                        controller.sendImage();
                      } else if (value == 'file') {
                        controller.sendFile();
                      }
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.messageController.value,
                      decoration: const InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      controller.sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
