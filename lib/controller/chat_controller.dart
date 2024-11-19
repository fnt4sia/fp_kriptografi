import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fp_kriptografi/shared/utils/crpyto_utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChatController extends GetxController {
  final Rx<TextEditingController> messageController =
      TextEditingController().obs;
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxString chatId = ''.obs;
  final RxString username = ''.obs;
  final RxString currentUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentUserId.value = Get.arguments['currentId'];
    chatId.value = Get.arguments['chatId'];
    username.value = Get.arguments['username'];
    fetchMessages();
  }

  void fetchMessages() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
        .collection('chats')
        .doc(chatId.value)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'senderId': data['senderId'],
          'content': data['content'],
          'timestamp': data['timestamp'],
          'type': data['type'],
          'hasMessage':
              data.containsKey('hasMessage') ? data['hasMessage'] : false,
        };
      }).toList();
    });
  }

  Future<void> sendMessage() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (messageController.value.text.trim().isEmpty) return;

    await firestore
        .collection('chats')
        .doc(chatId.value)
        .collection('messages')
        .add(
      {
        'senderId': currentUserId.value,
        'content': messageController.value.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      },
    );

    await firestore.collection('chats').doc(chatId.value).set(
      {
        'lastMessage': messageController.value.text.trim(),
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    messageController.value.clear();
  }

  Future<void> sendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // File file = File(result.files.single.path!);
    }
  }

  Future<void> sendImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      File file = File(result.files.single.path!);
      String hiddenMessage = messageController.value.text.trim();

      File stegoImage;

      if (hiddenMessage.isNotEmpty) {
        stegoImage = await CrpytoUtils.hideDataInImage(
          file,
          hiddenMessage,
        );
      } else {
        stegoImage = file;
      }
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String uniquePath = 'images/$currentUserId/$timeStamp.png';

      Reference ref =
          FirebaseStorage.instance.ref().child('images/$uniquePath');
      await ref.putFile(stegoImage);

      String downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId.value)
          .collection('messages')
          .add({
        'senderId': currentUserId.value,
        'content': downloadUrl,
        'type': 'image',
        'hasMessage': hiddenMessage.isNotEmpty,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId.value)
          .set(
        {
          'lastMessage': "Image",
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      messageController.value.clear();
    }
  }

  Future<String> receiveImage(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        String tempPath = directory.path;
        String filePath = '$tempPath/temp_image.png';

        File imageFile = File(filePath);
        await imageFile.writeAsBytes(response.bodyBytes);

        String? hiddenMessage =
            await CrpytoUtils.extractDataFromImage(imageFile);

        return hiddenMessage ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print("error disini bang : receive image");
      print(e.toString());
      return '';
    }
  }
}
