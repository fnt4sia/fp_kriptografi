import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bcrypt/bcrypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CrpytoUtils {
  static final key = Key.fromUtf8('inibutuh32karakterjadinyangasall');
  static final iv = IV.fromSecureRandom(16);

  static String hashPassword(String password) {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  static bool verifyPassword(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
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
      return null;
    }
  }

  static List<int> encryptByes(List<int> bytes) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encryptedData = e.encryptBytes(bytes, iv: iv);
    return encryptedData.bytes;
  }

  static Future<List<int>> decryptBytes(List<int> encryptedBytes) async {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final decryptedBytes = encrypter.decryptBytes(
      Encrypted(Uint8List.fromList(encryptedBytes)),
      iv: iv,
    );

    return decryptedBytes;
  }

  static String caesarCipher(String text, bool isEncrypt) {
    const int asciiLowerA = 97;
    const int asciiLowerZ = 122;
    const int asciiUpperA = 65;
    const int asciiUpperZ = 90;

    int shift = 3;
    shift = isEncrypt ? shift : -shift;

    String resultText = '';

    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);

      if (charCode >= asciiUpperA && charCode <= asciiUpperZ) {
        charCode = ((charCode - asciiUpperA + shift) % 26);
        if (charCode < 0) charCode += 26;
        charCode += asciiUpperA;
      } else if (charCode >= asciiLowerA && charCode <= asciiLowerZ) {
        charCode = ((charCode - asciiLowerA + shift) % 26);
        if (charCode < 0) charCode += 26;
        charCode += asciiLowerA;
      }

      resultText += String.fromCharCode(charCode);
    }

    return resultText;
  }

  static String vigenereCipher(String text, bool isEncrypt) {
    String key = 'SECRET';
    key = key.toUpperCase();
    String result = '';
    int keyIndex = 0;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        int charCode = char.toUpperCase().codeUnitAt(0) - 65;
        int keyCode = key[keyIndex % key.length].codeUnitAt(0) - 65;
        int shift = isEncrypt ? keyCode : -keyCode;
        int newCharCode = (charCode + shift) % 26;
        if (newCharCode < 0) newCharCode += 26;
        result += String.fromCharCode(
            newCharCode + (char == char.toUpperCase() ? 65 : 97));
        keyIndex++;
      } else {
        result += char;
      }
    }

    return result;
  }

  static String xorCipher(String text) {
    int key = 42;
    return String.fromCharCodes(text.codeUnits.map((unit) => unit ^ key));
  }

  static String superCipher(String text, bool isEncrypt) {
    if (isEncrypt) {
      String caesarText = caesarCipher(text, true);
      String vigenereText = vigenereCipher(caesarText, true);
      String result = xorCipher(vigenereText);
      return result;
    } else {
      String xorText = xorCipher(text);
      String vigenereText = vigenereCipher(xorText, false);
      String result = caesarCipher(vigenereText, false);
      return result;
    }
  }
}
