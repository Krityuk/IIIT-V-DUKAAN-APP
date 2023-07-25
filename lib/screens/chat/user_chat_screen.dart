import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/screens/chat/chat_stream.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

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
    }
  }

  @override
  void initState() {
    super.initState();
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
                      onPressed: sendMessage,
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
