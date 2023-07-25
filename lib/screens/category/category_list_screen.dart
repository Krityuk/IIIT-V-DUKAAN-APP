import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/screens/location_screen.dart';
import 'package:provider/provider.dart';

import 'package:icd_kaa_olx/screens/category/product_by_category_screen.dart';

import '../../constants/colors.dart';
import '../../forms/common_form.dart';
import '../../provider/category_provider.dart';
import '../../services/auth.dart';
import '../../services/user.dart';

class CategoryListScreen extends StatefulWidget {
  static const String screenId = 'category_list_screen';
  final bool? isForForm;
  const CategoryListScreen({Key? key, this.isForForm}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  UserService firebaseUser = UserService();
  bool isLocationFilled = false;

  @override
  void initState() {
    firebaseUser.getUserData().then((value) {
      if (value['address'] != null) {
        isLocationFilled = true;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        iconTheme: IconThemeData(color: whiteColor),
        title: Text(
          'Select Category',
          style: TextStyle(color: redColor),
        ),
      ),
      body: _body(categoryProvider),
    );
  }

  _body(categoryProvider) {
    Auth authService = Auth();

    return FutureBuilder<QuerySnapshot>(
        future: authService.categories.orderBy('category_name').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                var doc = snapshot.data?.docs[index];
                return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                        onTap: () {
                          //****************************************************************** */
                          if (isLocationFilled == true) {
                            categoryProvider.setCategory(doc['category_name']);
                            // HAR index KI APNI APNI doc['category_name'] HAI
                            categoryProvider.setCategorySnapshot(doc);
                            if (widget.isForForm == true) {
                              Navigator.of(context)
                                  .pushNamed(CommonForm.screenId);
                            } else {
                              Navigator.of(context)
                                  .pushNamed(ProductByCategory.screenId);
                            }
                          }
                          if (isLocationFilled == false) {
                            Navigator.of(context)
                                .pushNamed(LocationScreen.screenId);
                          }
                        },
                        leading: Card(
                          elevation: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              doc!['img'],
                              width: 60,
                              height: 80,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: Text(
                          doc['category_name'],
                          style: TextStyle(fontSize: 15, color: whiteColor),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: whiteColor,
                        )));
              }));
        });
  }
}
