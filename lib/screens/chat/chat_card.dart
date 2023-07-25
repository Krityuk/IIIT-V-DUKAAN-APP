import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/constants/colors.dart';
import 'package:icd_kaa_olx/constants/widgets.dart';
import 'package:icd_kaa_olx/screens/chat/user_chat_screen.dart';
import 'package:intl/intl.dart';

// import '../../constants/colors.dart';
import '../../services/auth.dart';
import '../../services/user.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic>
      chatsDoc; // this data is collection("msg") ka ek  doc
  const ChatCard({Key? key, required this.chatsDoc}) : super(key: key);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  UserService firebaseUser = UserService();
  Auth authService = Auth();
  //
  DocumentSnapshot? productData;
  String? lastChatDate = '';

//******************************************************************************************** */
  @override
  void initState() {
    getProductDetails(); //chat_card bnte hi initstate me hi pehle productData and lastChatDate me value aa gyi
    getChatTime();
    super.initState();
  }
//******************************************************************************************** */

  getProductDetails() {
    firebaseUser
        .getProductDetails(widget.chatsDoc['productDetails']['product_id'])
        .then((value) {
      setState(() {
        productData = value; //YAHA SETSTATE KI JGH AWAIT TRY KRNA
      });
    });
  }

//******************************************************************************************** */
  getChatTime() {
    var date = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(widget.chatsDoc['lastChatTime']));
    var today = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
        DateTime.now().microsecondsSinceEpoch));
    if (date == today) {
      setState(() {
        lastChatDate = 'Today';
      });
    } else {
      setState(() {
        lastChatDate = date.toString();
      });
    }
  }

//******************************************************************************************** */

// THESE CHAT CARDS ARE THE CARDS FOR MAIN CHAT SCREEN, THESE ARE NOT THE CHAT CARDS OF USERCHATSCREEN
  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return Container();
    } else {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 5, color: whiteColor),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            // color: Colors.black.withOpacity(0.2),
            child: Stack(
              children: [
                // 1
                ListTile(
                  onTap: () {
                    authService.messages
                        .doc(widget.chatsDoc['chatroomId'])
                        .update({
                      'read': 'true',
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => UserChatScreen(
                                  chatroomId: widget.chatsDoc['chatroomId'],
                                )));
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      productData!['images'][0],
                      width: 60,
                      height: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData!['title'],
                        style: TextStyle(
                            fontWeight: widget.chatsDoc['read'] == true
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: widget.chatsDoc['read'] == true
                                ? Colors.orangeAccent
                                : Colors.tealAccent),
                      ),
                      const Divider(
                        height: 5,
                        color: Colors.tealAccent,
                      )
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData!['descr'],
                        maxLines: 1,
                        style: TextStyle(color: whiteColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.chatsDoc['lastChat'] != null)
                        Text(
                          widget.chatsDoc['lastChat'],
                          style: TextStyle(color: whiteColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                    ],
                  ),
                  trailing: threeDotsButton(
                      context: context,
                      chatroomId: widget.chatsDoc['chatroomId'],
                      isWhiteColored: true),
                ),
                // 2
                Positioned(
                  right: 20,
                  child: Text(
                    lastChatDate!,
                    style: TextStyle(
                        color: (widget.chatsDoc['read'] == true)
                            ? Colors.orangeAccent
                            : whiteColor),
                  ),
                )
                //********************************************* */
              ],
            ),
          ),
        ),
      );
    }
  }
}
