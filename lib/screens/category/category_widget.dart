import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/screens/category/product_by_category_screen.dart';
import 'package:provider/provider.dart';

import 'package:icd_kaa_olx/constants/colors.dart';
import 'package:icd_kaa_olx/screens/category/category_list_screen.dart';

import '../../provider/category_provider.dart';
import '../../services/auth.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  Auth myAuthService = Auth();

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return Container(
      height:
          kIsWeb ? screenHeight(context) * 0.19 : screenHeight(context) * 0.18,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: FutureBuilder<QuerySnapshot>(
        future: myAuthService.categories
            //'categories' is the collection name of firestore,  see myAuthService.categories is def in auth.dart file
            .orderBy('category_name', descending: false)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading categories'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                //     child: CircularProgressIndicator(
                //   color: secondaryColor,
                // ),
                );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, CategoryListScreen.screenId),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      Row(
                        children: [
                          Text(
                            'See All',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: linkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: linkColor,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true, //maintains overflow,idk its meaning
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        var doc = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            categoryProvider.setCategory(doc['category_name']);
                            //category widget ka selectedCategory=doc['category_name'] kr do, Class categoryProvider se associated ek static string h-'selectedCategory'
                            //ab current category=doc['category_name'] hai
                            categoryProvider.setCategorySnapshot(doc);
                            Navigator.of(context)
                                .pushNamed(ProductByCategory.screenId);
                          },
                          child: Card(
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        doc['img'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      doc['category_name'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: blackColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
