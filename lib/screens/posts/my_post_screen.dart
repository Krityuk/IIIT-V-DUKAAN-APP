import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../services/auth.dart';
import '../../services/user.dart';
import '../product/product_tile.dart';

class MyPostScreen extends StatefulWidget {
  static const screenId = 'my_post_screen';
  const MyPostScreen({Key? key}) : super(key: key);

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  Auth myAuthService = Auth();
  UserService firebaseUser = UserService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: greyColor,
        appBar: AppBar(
          toolbarHeight: kIsWeb ? screenHeight(context) * 0.115 : null,
          backgroundColor: blackColor,
          elevation: 0,
          title: Text(
            'My Posts',
            style: TextStyle(color: redColor, fontFamily: 'Times'),
          ),
          bottom: TabBar(indicatorColor: secondaryColor, tabs: const [
            Tab(
              child: Text(
                'My Posts',
                style: TextStyle(color: Colors.tealAccent),
              ),
            ),
            Tab(
              child: Text(
                'Favourites',
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
          ]),
        ),
        body: bodyWidget(
            myAuthService: myAuthService, firebaseUser: firebaseUser),
      ),
    );
  }
}

bodyWidget({required Auth myAuthService, required UserService firebaseUser}) {
  final numberFormat = NumberFormat('##,##,##0');
  return TabBarView(children: [
    FutureBuilder<QuerySnapshot>(
        future: myAuthService.products
            .where('seller_uid', isEqualTo: firebaseUser.user!.uid)
            .orderBy('posted_at') // indexing
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products..'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          }
          final filteredSnapshot = snapshot.data!.docs
              .where((doc) => !doc['isDeleted']) // Filter out deleted products
              .toList();

          if (filteredSnapshot.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 50,
              child: const Center(
                child: Text('No Posts Added by you...'),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2,
                        mainAxisExtent: 250,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredSnapshot.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = filteredSnapshot[index];
                        var price = int.parse(data['price']);
                        String formattedPrice = numberFormat.format(price);
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black, // Set the border color
                              width: 2, // Set the border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: ProductCard(
                                data: data,
                                formattedPrice: formattedPrice,
                                numberFormat: numberFormat,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        }),
    //******************************************************************************************************* */
    // 2nd TabBarView
    StreamBuilder<QuerySnapshot>(
        stream: myAuthService.products
            .where('favourites', arrayContains: firebaseUser.user!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products..'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          }
          final filteredSnapshot = snapshot.data!.docs
              .where((doc) => !doc['isDeleted']) // Filter out deleted products
              .toList();
          if (filteredSnapshot.isEmpty) {
            return Center(
              child: Text(
                'No Favourites...',
                style: TextStyle(
                  color: blackColor,
                ),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2,
                        mainAxisExtent: 250,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredSnapshot.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = filteredSnapshot[index];
                        var price = int.parse(data['price']);
                        String formattedPrice = numberFormat.format(price);
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black, // Set the border color
                              width: 2, // Set the border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: ProductCard(
                                data: data,
                                formattedPrice: formattedPrice,
                                numberFormat: numberFormat,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        }),
  ]);
}
