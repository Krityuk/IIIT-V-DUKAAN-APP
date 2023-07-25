import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // The intl package is used for internationalization and localization in Dart,//and it is for formatting the dates, numbers, and messages according to different locales
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../provider/category_provider.dart';
import '../screens/product/product_tile.dart';
import '../services/auth.dart';

class ProductListing extends StatefulWidget {
  final bool? isProductByCategory;

  const ProductListing({Key? key, this.isProductByCategory}) : super(key: key);

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  Auth myAuthService = Auth();

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    final numberFormat = NumberFormat('##,##,##0');
    return FutureBuilder<QuerySnapshot>(
        future: (widget.isProductByCategory == true)
            ? myAuthService.products
                .orderBy('posted_at')
                .where('category', isEqualTo: categoryProvider.selectedCategory)
                .get()
// NOTE HERE THAT YAHA INDEXING KRNA BHUL GYE THE TO YE NAI CHAL RHA THA,'posted_at' & 'category' do attributes use kr rhe eksath to firebase me indexing to krna hi prega warna nai chalega eksath
            : myAuthService.products.orderBy('posted_at').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products..'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                // child: CircularProgressIndicator(
                //   color: secondaryColor,
                // ),
                );
          }
          //***************************************************************** */
          // CREATE FILTERED SNAPSHOT HERE SUCH THAT .where('isDeleted', isEqualTo: false)
          final filteredSnapshot = snapshot.data!.docs
              .where((doc) => !doc['isDeleted']) // Filter out deleted products
              .toList();

          return (filteredSnapshot.isEmpty)
              ? SizedBox(
                  height: screenHeight(context) * 0.8,
                  child: Center(
                    child: Text('No Products Found.',
                        style: TextStyle(color: whiteColor)),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isProductByCategory == null)
                        SizedBox(
                          child: Column(
                            children: const [
                              Text(
                                'Recommended For You',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      GridView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 2 / 2.8,
                            mainAxisExtent: 225,
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 10,
                          ),
                          // itemCount: filteredSnapshot.data!.size,
                          itemCount: filteredSnapshot.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = filteredSnapshot[index];
                            var price = int.parse(data['price']);
                            String formattedPrice = numberFormat.format(price);
                            // return Center(
                            //   child: Container(
                            //     color: linkColor,
                            //   ),
                            // );
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: whiteColor,
                                    width: 1,
                                  ),
                                ),
                                child: ProductCard(
                                  data: data, //productData
                                  formattedPrice: formattedPrice,
                                  numberFormat: numberFormat,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                );
        });
  }
}
