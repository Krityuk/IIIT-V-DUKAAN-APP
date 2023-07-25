import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/product_listing_widget.dart';
import '../../constants/colors.dart';
import '../../provider/category_provider.dart';

class ProductByCategory extends StatelessWidget {
  static const String screenId = 'product_by_category';
  const ProductByCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        title: Text(
          '${categoryProvider.selectedCategory}',
          style: TextStyle(
            color: whiteColor,
          ),
        ),
      ),
      body: const SingleChildScrollView(
          child: ProductListing(
        isProductByCategory: true,
      )),
    );
  }
}
