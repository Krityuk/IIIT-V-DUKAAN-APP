import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/services/auth.dart';

Auth myAuthService = Auth();

Future<List<String>> getImageUrlsFromStorage() async {
  List<String> imageUrls = [];

  // Get a reference to the "category" folder in Firebase Storage
  Reference storageRef = FirebaseStorage.instance.ref().child('category');

  // List all items (images) within the "category" folder
  ListResult storageResult = await storageRef.listAll();

  // Retrieve the download URLs for each image
  for (Reference imageRef in storageResult.items) {
    String imageUrl = await imageRef.getDownloadURL();
    debugPrint('$imageUrl       😎😎😎😎😎😎😎😎');
    imageUrls.add(imageUrl);
  }

  return imageUrls;
}

