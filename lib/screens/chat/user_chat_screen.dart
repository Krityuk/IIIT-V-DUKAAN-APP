// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
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
  const UserChatScreen({Key? key, this.chatroomId}) : super(key: key);

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

  sendMessage() {
    //****************************************************************************************** */
    //*************************  YAHA NOTIFIACATION DALO   ************************************* */
    //*************************                            ************************************* */
    //****************************************************************************************** */

    if (msgController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      // Above line means it unfocuses the current focus scope, which means removing focus from any active text input fields.removed focus from "Enter yr msg" wala textfield
      Map<String, dynamic> message = {
        'message': msgController.text,
        'sent_by': firebaseUser.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch,
      };

      firebaseUser.createChat(chatroomId: widget.chatroomId, message: message);
      msgController.clear();
      //
      // var productProvider = Provider.of<ProductProvider>(context);
      // log(productProvider.sellerDetails!['name']);
      // log(productProvider.sellerDetails!['pushTokenForMsging']);
      // try {
      //   sendPushNotification(firebaseUser.user!.uid,
      //       sellerDetails['pushTokenForMsging'], sellerDetails['name']);
      // } catch (e) {
      //   debugPrint(
      //       '${e.toString()}  error in firebase notification sending     😎😎😎😎😎😎😎😎');
      // }
    }
  }

  // msg sender ki auth uid de rha and msg receiver ka fcmPushToken kr de rha
  sendPushNotification(
      String senderUid, String recipientFcmPushToken, String name) async {
    // Construct the notification message
    final body = {
      // "to": recipientFcmPushToken,
      "to":
          "flTtl-t4S0q_dMmp13lo4m:APA91bHL0qp6swiSaRZ4PbEsqNK1j5qVU8EYvb-I2vuTGan1auxDuKnRSwQGEgOvtqnmDVFAQ2eUvS4OqNNH6QlpZUQV9U2cNLwAHk6vxienI7aY-qxmIJKKKAQQ07BRqOgxmi5bA7TO",
      "notification": {"title": name, "body": "Sent You A Msg"}
    };

    // Send the notification
    try {
      // await FirebaseMessaging.instance.send(message);
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
                    'tel:${productProvider.sellerDetails!['mobile']}');
                await _callLauncher(phoneNo);
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
        body: _body());
  }

  _body() {
    return Stack(
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
                          sendMessage();
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
                        sendMessage();
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
    );
  }
}
