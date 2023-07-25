import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../modals/product_model.dart';
import '../provider/product_provider.dart';
import '../services/auth.dart';
import '../services/search.dart';
import '../services/user.dart';

class MainAppBarWithSearch extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const MainAppBarWithSearch({
    required this.controller,
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<MainAppBarWithSearch> createState() => _MainAppBarWithSearchState();
}

class _MainAppBarWithSearchState extends State<MainAppBarWithSearch> {
  static List<Products> productsArray = [];
  Auth authService = Auth();

  Search searchService = Search();
  UserService firebaseUser = UserService();
  String address = '';
  DocumentSnapshot? sellerDetails;
  @override
  void initState() {
    // authService.products.get() means vo collection 'products'
    authService.products.get().then(((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        productsArray.add(Products(
            document: doc,
            title: doc['title'],
            description: doc['descr'],
            category: doc['category'],
            price: doc['price'],
            postDate: doc['posted_at']));
        //
        getSellerAddress(doc['seller_uid']);
      }
    }));
    super.initState();
  }

  getSellerAddress(sellerId) {
    firebaseUser.getSellerData(sellerId).then((value) => {
          setState(() {
            address = value['address'];
            sellerDetails = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductProvider>(context);
    return SafeArea(
      child: Container(
        height: screenHeight(context) * 0.85,
        color: Colors.transparent,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: FittedBox(
                    child: Text(
                      " HI ${firebaseUser.user!.displayName ?? 'ICDIAN'}   ",
                      style: const TextStyle(
                          fontFamily: 'Times',
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    searchService.funcSearchQueryPage(
                        context: context,
                        products: productsArray,
                        address: address,
                        sellerDetails: sellerDetails,
                        provider: provider);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: disabledColor.withOpacity(0.3),
                    ),
                    child: const Icon(
                      Icons.search,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
