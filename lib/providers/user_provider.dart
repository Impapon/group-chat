import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_day36/db/db_helper.dart';
import 'package:firebase_day36/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> remainingUserList = [];

  Future<void> addUser(UserModel userModel) {
    return DbHelper.addUser(userModel);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String uid) =>
      DbHelper.getUserById(uid);

  Future<String> updateImage(File file) async {
    final imageName = 'Image_${DateTime.now().millisecond}';
    final photoRef = FirebaseStorage.instance.ref().child("picture/$imageName");
    final task = photoRef.putFile(file);
    final snapshot = await task.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> map) =>
      DbHelper.updateProfile(uid, map);

  getAllRemainingUser(String uid) {
    DbHelper.getAllRemainingUsers(uid).listen((event) {
      remainingUserList = List.generate(event.docs.length,
          (index) => UserModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }
}
