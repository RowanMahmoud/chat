import 'package:chat/allConstants/constants.dart';
import 'package:chat/allConstants/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserChat {

  late String id;
  late String username;
  late String photoUrl;

  UserChat({
    required this.id,
    required this.username,
    required this.photoUrl,
  });

  Map<String, String> tojson() {
    return {
      FirestoreConstants.id: id,
      FirestoreConstants.username: username,
      FirestoreConstants.photoUrl: photoUrl,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc)
  {
    String id = "";
    String username = "";
    String photoUrl = "";

    try {
      id = doc.get(FirestoreConstants.id);
    } catch (e) {}
    try {
      id = doc.get(FirestoreConstants.username);
    } catch (e) {}
    try {
      id = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    return UserChat(
      id: doc.id,
      username: username,
      photoUrl: photoUrl,

    );
  }
}