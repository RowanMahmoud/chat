// import 'dart:html';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SettingProvider {
  late final SharedPreferences prefs;
  late final FirebaseFirestore firebaseFirestore;
  late final FirebaseStorage firebaseStorage;

  SettingProvider({
    required this.prefs,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  String? getPref(String key) {
    return prefs.getString(key);
  }

  Future<bool> setpref(String key, String value) async {
    return await prefs.setString(key, value);
  }

  UploadTask uploadFile(File Image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(Image);
    return uploadTask;
  }

  Future <void> updateDataFirestore(String collectionPath, String path,
      Map <String, String> dataNeedUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(path).update(
        dataNeedUpdate);
  }
}
