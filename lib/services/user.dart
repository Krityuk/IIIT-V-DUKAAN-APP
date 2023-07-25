import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/services/auth.dart';

import '../constants/widgets.dart';

class UserService {
  Auth myAuthService = Auth();
  User? user = FirebaseAuth.instance.currentUser;
  //Since we are logged in, so FirebaseAuth.instance.currentUser se current user ko access kr sakte hai,
  //jabtak FirebaseAuth.instance.logOut nahi run krte tabtak FirebaseAuth.instance.currentUser would return the current user.
  //Library wali app me accountId ko pass kr rhe the class to class (for accessing the account) after doing loggin,
  //but here FirebaseAuth use kr rhe so ,id ko pass krne ki jaroorat nai h class to class, FirebaseAuth.instance.currentUser is used here to access account after loggin

  // SIMPLY USING UPDATE FUNCTION (CRUD) IN THE FIRESTORE COLLECTION 'USERS'
  Future<void> updateFirebaseAccount(
      BuildContext context, Map<String, dynamic> data) {
    User? user = FirebaseAuth.instance.currentUser;
    return myAuthService.users //myAuthService is object of Auth class,
        .doc(user!.uid) //'users' is a collection in firestore database
        .update(data)
        .then((value) {
      // customSnackBar(context: context, content: 'Updated on database');
    }).catchError((error) {
      customSnackBar(
          context: context, content: 'Cannot update in database due to $error');
    });
  }

  // SIMPLY getUserData func:-
  Future<DocumentSnapshot> getUserData() async {
    //it is returning current user ka data
    DocumentSnapshot doc = await myAuthService.users.doc(user!.uid).get();
    return doc; // myAuthService.users is just the collection('users);
  }

  Future<DocumentSnapshot> getSellerData(id) async {
    // it is returning- ek id diya us id wale user ka data
    DocumentSnapshot doc = await myAuthService.users.doc(id).get();
    return doc;
  }

  Future<DocumentSnapshot> getProductDetails(id) async {
    //ek product id pass kiya , us id wale product ka data
    DocumentSnapshot doc = await myAuthService.products.doc(id).get();
    return doc;
  }

  updateFavourite(
      {required BuildContext context,
      required bool isLiked,
      required String productId}) {
    if (isLiked) {
      myAuthService.products.doc(productId).update({
        'favourites': FieldValue.arrayUnion([user!.uid])
        // NOTE here that har product (in the collection['products'] firestore) me ek atribute h- 'favourites' jo ki array hai and, is array me vo sab users ki id rhegi jo is product ko like kiye ho
        // BUT I AM THINKING TO ADD THIS PROPERTY INTO Collection['users'] as well,do it.
      });
      customSnackBar(context: context, content: 'Added to favourites');
    } else {
      myAuthService.products.doc(productId).update({
        'favourites': FieldValue.arrayRemove([user!.uid])
      });
      customSnackBar(context: context, content: 'Removed from favourites');
    }
  }

  createChatRoom({required Map<String, dynamic> data}) {
    myAuthService.messages
        .doc(data['chatroomId'])
        .set(data)
        .catchError((error) {
      debugPrint('${error.toString()} error in creatingChatRoom  😎😎😎😎');
    });
  }

  deleteChat({String? chatroomId}) async {
    return myAuthService.messages.doc(chatroomId).delete();
  }

  createChat({String? chatroomId, required Map<String, dynamic> message}) {
    myAuthService.messages
        .doc(chatroomId)
        .collection('chats')
        //har doc me ek attribute collection('chats') kr diya hai
        .add(message)
        .catchError((error) {
      debugPrint(error.toString());
    });
    myAuthService.messages.doc(chatroomId).update({
      'lastChat': message['message'],
      'lastChatTime': message['time'],
      'read': false,
    });// COLLECTION ("messeges") ke HAR doc ME CHAR FIELDS HAI,String lastChat,String  lastChatTime,String read, collection chats
  }

  getChatDetails({String? chatroomId}) async {
    return myAuthService.messages
        .doc(chatroomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }
}
