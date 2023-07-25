import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/user.dart';

class CategoryProvider with ChangeNotifier {
  //
  final UserService _firebaseUser = UserService();
  //

  DocumentSnapshot? doc;
  DocumentSnapshot<Map<String, dynamic>>? userDetails;
  String? selectedCategory;
  //
  List<String> imageUploadedUrls = [];
  Map<String, dynamic> formData = {};

  setCategory(selectedCategory) {
    this.selectedCategory = selectedCategory;
    notifyListeners();
  }

  setCategorySnapshot(snapshot) {
    doc = snapshot;
    notifyListeners();
  }

  setImageList(url) {
    imageUploadedUrls.add(url);
    debugPrint('${imageUploadedUrls.length}  imageUploadedUrls.length   😎😎');
    notifyListeners();
  }

  setFormData(data) {
    formData = data;
    notifyListeners();
  }

  getUserDetail() {
    // here we get all user data including the form part
    _firebaseUser.getUserData().then((value) {
      userDetails = value as DocumentSnapshot<Map<String, dynamic>>;
      notifyListeners();
    });
  }

  clearData() {
    imageUploadedUrls = [];
    formData = {};
    notifyListeners();
  }
}
