import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/screens/chat/chat_card.dart';

import '../../constants/colors.dart';
import '../../services/auth.dart';
import '../../services/user.dart';
import '../category/category_list_screen.dart';
import '../main_navigation_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String screenId = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Auth authService = Auth();
  UserService firebaseUser = UserService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: greyColor,
        appBar: AppBar(
            toolbarHeight: kIsWeb ? screenHeight(context) * 0.115 : null,
            backgroundColor: blackColor,
            title: Text(
              'Chats',
              style: TextStyle(color: redColor, fontFamily: 'Times'),
            ),
            bottom: _bottomBar()),
        body: _body(
          authService: authService,
          firebaseUser: firebaseUser,
        ),
      ),
    );
  }

//********************************************************************************************** */
  _bottomBar() {
    return TabBar(
        labelStyle: TextStyle(
          color: blackColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Oswald',
        ),
        labelColor: blackColor,
        indicatorColor: secondaryColor,
        tabs: const [
          Tab(
            child: Text(
              'All',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
          Tab(
            child: Text(
              'Buying',
              style: TextStyle(color: Colors.green),
            ),
          ),
          Tab(
            child: Text(
              'Selling',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ]);
  }
//*********************************************************************************************** */

  _body({required Auth authService, required UserService firebaseUser}) {
    return TabBarView(
      children: [
        // 1st TabBarView
        // here, Collection('msg') ke wo sare chats dikhenge jisme users array me currentUser ho (firebaseUser.user!.uid ho)
        StreamBuilder<QuerySnapshot>(
            stream: authService.messages
                .where('users', arrayContains: firebaseUser.user!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading chats..',
                        style: TextStyle(color: whiteColor)));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: secondaryColor),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ahhh! Start Selling/Buying...',
                        style: TextStyle(color: whiteColor)),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(blackColor)),
                        onPressed: () => Navigator.of(context)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (c) =>
                                        const MainNavigationScreen()),
                                (route) => false),
                        child: const Text('Recommended Products'))
                  ],
                ));
              }
              return Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ChatCard(chatsDoc: data);
                  }).toList(),
                ),
              );
            }),

        // 2nd TabBarView
        StreamBuilder<QuerySnapshot>(
            stream: authService.messages
                .where('users', arrayContains: firebaseUser.user!.uid)
                // .where('productDetails.seller',
                //     isNotEqualTo: firebaseUser.user!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading chats..',
                        style: TextStyle(color: whiteColor)));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: secondaryColor),
                );
              }
              final filteredDocs = snapshot.data!.docs.where((document) {
                final List<dynamic> users = document.get('users');
                final String seller = document.get('productDetails.seller');
                return users.contains(firebaseUser.user!.uid) &&
                    seller != firebaseUser.user!.uid;
              }).toList();
              if (filteredDocs.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Wanna buy great products, here are some...',
                        style: TextStyle(color: whiteColor)),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(blackColor)),
                        onPressed: () => Navigator.of(context)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (c) =>
                                        const MainNavigationScreen()),
                                (route) => false),
                        child: const Text('See Latest Products'))
                  ],
                ));
              }
              return Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ListView(
                  children: filteredDocs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ChatCard(chatsDoc: data);
                  }).toList(),
                ),
              );
            }),

        // 3rd TabBarView
        StreamBuilder<QuerySnapshot>(
            stream: authService.messages
                .where('users', arrayContains: firebaseUser.user!.uid)
                // .where('productDetails.seller',  // INDEXING NOT WORKING HERE,SO I BROKE THIS QUERY INTO TWO PARTS
                //     isEqualTo: firebaseUser.user!.uid) //I.E.. USING FILTERED DOCS
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading chats..',
                        style: TextStyle(color: whiteColor)));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: secondaryColor),
                );
              }
              final filteredDocs = snapshot.data!.docs.where((document) {
                final List<dynamic> users = document.get('users');
                final String seller = document.get('productDetails.seller');
                return users.contains(firebaseUser.user!.uid) &&
                    seller == firebaseUser.user!.uid;
              }).toList();
              if (filteredDocs.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('No chats yet ? Start Now !',
                        style: TextStyle(color: whiteColor)),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(blackColor)),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const CategoryListScreen(
                                      isForForm: true,
                                    ))),
                        child: const Text('Add Products'))
                  ],
                ));
              }
              return Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ListView(
                  children: filteredDocs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ChatCard(chatsDoc: data);
                  }).toList(),
                ),
              );
            }),
      ],
    );
  }
}


//******************************************************************************************* */
// 2nd TabBarView  // I USED TWO WHERES TOGETTHER HERE BUT INDEXING NOT WORKED SO I GONE FOE FILTERED DOCS APPROACH INSTEAD OF THIS
        // StreamBuilder<QuerySnapshot>(
        //     stream: authService.messages
        //         .where('users', arrayContains: firebaseUser.user!.uid)
        //         .where('productDetails.seller',
        //             isNotEqualTo: firebaseUser.user!.uid)
        //         .snapshots(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //       if (snapshot.hasError) {
        //         return const Center(child: Text('Error loading chats..'));
        //       }
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Center(
        //           child: CircularProgressIndicator(color: secondaryColor),
        //         );
        //       }
        //       if (snapshot.data!.docs.isEmpty) {
        //         return Center(
        //             child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             const Text('Wanna buy great products, here are some...'),
        //             const SizedBox(
        //               height: 10,
        //             ),
        //             ElevatedButton(
        //                 style: ButtonStyle(
        //                     backgroundColor:
        //                         MaterialStateProperty.all(blackColor)),
        //                 onPressed: () => Navigator.of(context)
        //                     .pushAndRemoveUntil(
        //                         MaterialPageRoute(
        //                             builder: (c) =>
        //                                 const MainNavigationScreen()),
        //                         (route) => false),
        //                 child: const Text('See Latest Products'))
        //           ],
        //         ));
        //       }
        //       return ListView(
        //         children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //           Map<String, dynamic> data =
        //               document.data() as Map<String, dynamic>;
        //           return ChatCard(chatsDoc: data);
        //         }).toList(),
        //       );
        //     }),
