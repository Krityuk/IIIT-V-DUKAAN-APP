// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/services/get_imgurl_from_storage.dart';
import 'package:icd_kaa_olx/services/global.dart';
import 'package:provider/provider.dart';

import 'package:icd_kaa_olx/screens/chat/chat_stream.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../constants/colors.dart';
import '../../constants/widgets.dart';
import '../../provider/product_provider.dart';
import '../../services/user.dart';

class UserChatScreen extends StatefulWidget {
  static const String screenId = 'user_chat_screen';
  final String? chatroomId;
  const UserChatScreen({
    Key? key,
    this.chatroomId,
  }) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  TextEditingController msgController = TextEditingController();
  UserService firebaseUser = UserService();
  //Userservice is used to get current loginned user's data generally

  bool send = false;

  Future<void> _callLauncher(phoneNo) async {
    if (!await launchUrl(phoneNo)) {
      throw 'Could not launch $phoneNo';
    }
  }

  @override
  void dispose() {
    msgController.dispose(); //IT IS "ENTER YOUR MSG..." TEXTFIELD KA CONTROLLER
    super.dispose();
  }

  sendMessage(ProductProvider productProvider) async {
    //****************************************************************************************** */
    //*************************  YAHA NOTIFIACATION DALO   ************************************* */
    //*************************                            ************************************* */
    //****************************************************************************************** */
    if (msgController.text.isNotEmpty) {
      debugPrint('STARTING SEND MESSAGE FUNC HERE      😎😎😎😎😎😎😎😎');
      FocusScope.of(context).unfocus();
      // Above line means it unfocuses the current focus scope, which means removing focus from any active text input fields.removed focus from "Enter yr msg" wala textfield
      Map<String, dynamic> message = {
        'message': msgController.text,
        'sent_by': firebaseUser.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch,
      };
      String msg = msgController.text;

      firebaseUser.createChat(chatroomId: widget.chatroomId, message: message);
      msgController.clear();
      //
      debugPrint("${productProvider.sellerDetails!['name']} is seller");
      debugPrint(
          "${productProvider.sellerDetails!['pushTokenForMsging']} is seller's token\n\n");
      debugPrint('LETS ASSUME KI SELLER KO NOTIFICATION BHEJNA H   😎😎😎😎');
      String recipientFcmPushToken =
          productProvider.sellerDetails!['pushTokenForMsging'];
      if (productProvider.sellerDetails!.id == firebaseUser.user!.uid) {
        //same hai ye dono thus purchaser ko notification bhejna hoga is msg ka
        debugPrint(
            'MY ASSUMPTION CAME FALSE SO CORRECTING MY ASSUMPTION    😎😎😎😎😎😎😎😎');
        String receiverUid = (firebaseUser.user!.uid == Global.ChatUsers.first)
            ? Global.ChatUsers.last
            : Global.ChatUsers.first;
        log("ASSUMPTION CORRECTED IS = $receiverUid uid KO NOTIFICATION BHEJNA H");

        await myAuthService.users.doc(receiverUid).get().then((value) async {
          recipientFcmPushToken = value['pushTokenForMsging'];
          log("if condition ran i.e..assumption was wrong");
          log("recipientFcmPushToken is $recipientFcmPushToken <--isi ko notification bhejna hai");
        });
      } else {
        debugPrint(
            'MY ASSUMPTION WAS RIGHT, SELLER KO NOTIFICATION BHEJ RHE😎');
      }

      String senderName =
          'ICD DUKAAN'; //ICD DUKAAN sent you a message aayega ya <senderName><chatMessage>  aayega notification me
      await myAuthService.users.doc(firebaseUser.user!.uid).get().then((value) {
        senderName = value['name'];
      }).then((value) {
        try {
          sendPushNotification(
              firebaseUser.user!.uid, recipientFcmPushToken, senderName, msg);
          log("$recipientFcmPushToken ko notification bhej rhe is final decision");
        } catch (e) {
          debugPrint(
              '${e.toString()}  error in firebase notification sending     😎😎😎😎😎😎😎😎');
        }
      });
    }
  }

  // msg sender ki auth uid de rha and msg receiver ka fcmPushToken kr de rha
  sendPushNotification(String senderUid, String recipientFcmPushToken,
      String senderName, msg) async {
    // Construct the notification message
    final body = {
      "to": recipientFcmPushToken,
      // "to":
      //     "d0pCTRyKSJahlFkeZma5eR:APA91bEUYj1ntrriXdqhtYhdG83RhLeTAWxqY1G5O0bjtWnP29i6VyXIMb7x5J-3OUQ4B-PjqfswI1VygG8agJf4NIolV6dRfsQTxW4bepPvz1AvN8tkUYrjv1p5gMqhI4MjyljySxuC",
      "notification": {"title": senderName, "body": msg}
    };

    // Send the notification
    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        //THIS IS A SPECIAL LINK FOR FCM MESSENGING
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAAbYzxbIA:APA91bG1cbbYIgibk0ZZ4sAeONsMsYZzo5M48pS5rNEr_q1YlNvPm-EQ4B5FrtztAOMr7QnQ014KRCitR13nw0zu0JEazOOsFUJIrYnqxRa2x4vc88bly2oj_4w3ERgTqVtSauGLFmoO'
          // above key is server key, its associated to firebase project, go to settings->Cloud Msg API for getting this key
          // (or see my bookmarked video for sending notifications in chrome)
        },
        body: jsonEncode(body),
      );
      log("${response.statusCode} is your status code");
      log(response.body);

      debugPrint('Push notification sent successfully.');
    } catch (e) {
      debugPrint('Error sending push notification: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('Chat Screen Opened       😎😎😎😎😎😎😎😎');
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          iconTheme: IconThemeData(color: blackColor),
          title: Text(
            'Chat Details',
            style: TextStyle(color: blackColor),
          ),
          actions: [
            //1
            IconButton(
              onPressed: () async {
                var phoneNo = Uri.parse(
                    'tel:${productProvider.sellerDetails!['mobile']}'); ////////////////////////////////////*************** */
                debugPrint('call button pressed       😎😎😎😎😎😎😎😎');
                log(productProvider.sellerDetails!['mobile']);
                log(productProvider.sellerDetails!['name']);
                log(firebaseUser.user!.uid);
                log(productProvider.sellerDetails!.id);
                debugPrint('       😎😎😎😎😎😎😎😎');
                // log(Global.ChatUsers![0]);
                // log(Global.ChatUsers![1]);

                if (productProvider.sellerDetails!.id !=
                    firebaseUser.user!.uid) {
                  await _callLauncher(phoneNo);
                } else {
                  // suppose vo case jab seller and currentUser same hi ho us time vo seller ko thodi na call krega seller to vo khud hai, vo dusre ko call krega na so that's why neeche ye else condition bnana pra
                  try {
                    String messengerUid =
                        (firebaseUser.user!.uid == Global.ChatUsers.first)
                            ? Global.ChatUsers.last
                            : Global.ChatUsers.first;
                    log("$messengerUid is the messengeruid person to call");
                    // fetching his no to call him
                    myAuthService.users
                        .doc(messengerUid)
                        .get()
                        .then((value) async {
                      var msgMobileNo = Uri.parse('tel:${value['mobile']}');

                      await _callLauncher(msgMobileNo);
                    });
                  } catch (e) {
                    customSnackBar(context: context, content: "No Not Found");
                  }
                }
              },
              icon: const Icon(Icons.call),
              color: greenColor,
            ),
            //2
            threeDotsButton(
              context: context,
              chatroomId: widget.chatroomId,
            ),
          ],
        ),
        body: Stack(
          children: [
            //************************************************************* */
            //child 1
            ChatStream(
              chatroomId: widget.chatroomId,
            ),
            //************************************************************* */
            //child 2
            // BELOW Container IS THE SENDING MESSAGE BOX, IN WHICH ENTER YOUR MSG IS WRITTEN
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  border: Border(
                    top: BorderSide(
                      color: disabledColor.withOpacity(0.4),
                    ),
                    left: BorderSide(
                      color: disabledColor.withOpacity(0.4),
                    ),
                    right: BorderSide(
                      color: disabledColor.withOpacity(0.4),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                send = true;
                              });
                            } else {
                              setState(() {
                                send = false;
                              });
                            }
                          },
                          onSubmitted: (value) {
                            // Pressing Enter and Sending Message Case
                            if (value.isNotEmpty) {
                              log("Submitted button tapped");
                              sendMessage(productProvider);
                              log(productProvider.sellerDetails!['name']);
                            }
                          },
                          controller: msgController,
                          style: TextStyle(
                            color: blackColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your message...',
                            hintStyle: TextStyle(
                              color: blackColor,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file),
                      ),
                      Visibility(
                        visible: send,
                        child: IconButton(
                          onPressed: () {
                            sendMessage(productProvider);
                            log(productProvider.sellerDetails!['name']);
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  
  }
}
