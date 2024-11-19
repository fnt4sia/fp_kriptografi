import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtils {
  static Future<List> getAccount() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('account').get();

      List<Map<String, dynamic>> accountList = snapshot.docs.map((doc) {
        return {
          'username': doc['username'],
          'iv': doc['iv'],
          'password': doc['password'],
        };
      }).toList();

      return accountList;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>>
      fetchAccountsAndLastMessages() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> contacts = [];

    QuerySnapshot accountsSnapshot =
        await firestore.collection('account').get();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserId = prefs.getString('userId') ?? '';

    for (var doc in accountsSnapshot.docs) {
      String userId = doc.id;
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

      if (userId == currentUserId) continue;

      String chatId = currentUserId.compareTo(userId) < 0
          ? '${currentUserId}_$userId'
          : '${userId}_$currentUserId';

      DocumentSnapshot chatDoc =
          await firestore.collection('chats').doc(chatId).get();

      String lastMessage = '';
      if (chatDoc.exists) {
        lastMessage = chatDoc['lastMessage'] ?? '';
      }

      contacts.add({
        'userId': userId,
        'username': userData['username'],
        'lastMessage': lastMessage,
        'chatId': chatId,
      });
    }

    return contacts;
  }
}
