import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CrpytoUtils {
  static final key = Key.fromUtf8('inibutuh32karakterjadinyangasall');
  static final iv = IV.fromSecureRandom(16);

  static List encPass(String text) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encryptedData = e.encrypt(text, iv: iv);
    return [encryptedData.base64, iv.base64];
  }

  static String decPass(List<String> encryptedDataAndIv) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final iv = IV.fromBase64(encryptedDataAndIv[1]);
    final encryptedData = Encrypted.fromBase64(encryptedDataAndIv[0]);
    final decryptedData = e.decrypt(encryptedData, iv: iv);
    return decryptedData;
  }

  static Future<File> hideDataInImage(
    File imageFile,
    String secretData,
  ) async {
    try {
      img.Image? image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) {
        throw Exception("Failed to decode image");
      }

      final pixels = image.getBytes();

      List<int> secretBytes = utf8.encode(secretData).toList();
      secretBytes.add(0);

      int totalBits = secretBytes.length * 8;
      int pixelDataLength = pixels.length;
      int dataBitIndex = 0;

      if (totalBits > (pixelDataLength * 3) ~/ 4) {
        throw Exception("Image is too small to hide the full message.");
      }

      for (int i = 0; i < pixelDataLength; i++) {
        if ((i + 1) % 4 == 0) {
          continue;
        }

        if (dataBitIndex >= totalBits) {
          break;
        }

        int byteIndex = dataBitIndex ~/ 8;
        int bitIndex = 7 - (dataBitIndex % 8);
        int bit = (secretBytes[byteIndex] >> bitIndex) & 0x01;

        pixels[i] = (pixels[i] & 0xFE) | bit;

        dataBitIndex++;
      }

      final updatedImage = img.Image.fromBytes(
        width: image.width,
        height: image.height,
        bytes: pixels.buffer,
      );

      final directory = await getApplicationDocumentsDirectory();

      String fileName = 'updated_image.png';

      final outputPath = '${directory.path}/$fileName';

      File outputImage = File(outputPath);
      await outputImage.writeAsBytes(img.encodePng(updatedImage));

      return outputImage;
    } catch (e) {
      return imageFile;
    }
  }

  static Future<String?> extractDataFromImage(File imageFile) async {
    try {
      img.Image? image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) {
        throw Exception("Failed to decode image");
      }

      final pixels = image.getBytes();

      List<int> secretBytes = [];
      int dataBitIndex = 0;
      int byteValue = 0;

      for (int i = 0; i < pixels.length; i++) {
        if ((i + 1) % 4 == 0) {
          continue;
        }

        int bit = pixels[i] & 0x01;
        byteValue = (byteValue << 1) | bit;
        dataBitIndex++;

        if (dataBitIndex % 8 == 0) {
          if (byteValue == 0) {
            break;
          }
          secretBytes.add(byteValue);
          byteValue = 0;
        }
      }

      if (secretBytes.isEmpty) {
        return null;
      }

      String secretMessage = utf8.decode(secretBytes);
      return secretMessage;
    } catch (e) {
      print("error disini bang : extract data from image");
      print(e.toString());
      return null;
    }
  }
}
