import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_kriptografi/shared/utils/crpyto_utils.dart';

class LoginRegisterUtils {
  static Future<bool> createAccount(
    String email,
    String password,
    String username,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot snapshot = await firestore
          .collection('account')
          .where('username', isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await firestore
            .collection('account')
            .doc(snapshot.docs.first.id)
            .delete();
      }

      final List<dynamic> newPass = CrpytoUtils.encPass(password);

      await firestore.collection('account').add({
        "email": email,
        "password": newPass[0],
        "iv": newPass[1],
        "username": username,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> tryLogin(String username, String password) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('account')
          .where('username', isEqualTo: username)
          .get();

      if (snapshot.docs.isEmpty) {
        return null; 
      }

      final userDoc = snapshot.docs.first;
      final encryptedPassword = userDoc['password'];
      final iv = userDoc['iv'];

      final decryptedPassword = CrpytoUtils.decPass([encryptedPassword, iv]);

      if (decryptedPassword == password) {
        return userDoc.id; 
      }

      return null; 
    } catch (e) {
      return null;
    }
  }
}
