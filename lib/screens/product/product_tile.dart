import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/screens/product/product_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../provider/product_provider.dart';
import '../../services/auth.dart';
import '../../services/user.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.data, // it is product ka data, product['category'], etc
    required this.formattedPrice, //it is just the product['price'] in format
    required this.numberFormat,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final String formattedPrice;
  final NumberFormat numberFormat;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Auth myAuthService = Auth();
  UserService firebaseUser = UserService();

  String address = '';
  DocumentSnapshot? sellerDetails;
  bool isLiked = false;
  List fav = [];
  @override
  void initState() {
    initializeData();
    super.initState();
    //setFavourites func and getSellerData func ko await me rkhna tha, but listen note that we can never use asyncc/await in intstate,its rule, so
    //So To handle asynchronous operations in the initState method, you can create a separate method and call it inside initState
  }

  initializeData() async {
    await getSellerData(); // is await of initstate ka alternative yah hota h ki- func ke andar sbko if(mounted) me wrap kr do bas
    await setFavourites();
  }

  getSellerData() {
    firebaseUser.getSellerData(widget.data['seller_uid']).then((sellerData) {
      setState(() {
        address = sellerData['address'];
        sellerDetails = sellerData;
      });
    });
  }

  // below func determines for which of the productTiles are to be heartfilled and which are heart-outlined, and it has been called at initstate()
  setFavourites() {
    firebaseUser.getProductDetails(widget.data.id).then((productData) {
      setState(() {
        fav = productData['favourites'];
      });

      if (fav.contains(firebaseUser.user!.uid)) {
        // if fav list made here contains current user ki uid then make isLiked =true
        setState(() {
          isLiked = true;
        });
      } else {
        setState(() {
          isLiked = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    return InkWell(
      onTap: () {
        productProvider.setSellerDetails(sellerDetails);
        productProvider.setProductDetails(widget.data);
        Navigator.pushNamed(context, ProductDetail.screenId);
      },
      child: Card(
        elevation: 9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.data['images'][0],
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '₹ ${widget.formattedPrice}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          widget.data['descr'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      // Row(  // NOTE YAHA PR ADDRESS YA PHONE NO MAT DO WARNA KHARIDNE WALE KO YAHI SE ROOM NO PATA CHAL JAEGA TO VO CALL WALA FEATURE USE KREGA HI NAI
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     const Icon(
                      //       Icons.location_pin,
                      //       size: 14,
                      //     ),
                      //     const SizedBox(
                      //       width: 3,
                      //     ),
                      //     Flexible(
                      //       child: Text(
                      //         'Room No: $address',
                      //         maxLines: 2,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  right: -10,
                  bottom: 18,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        firebaseUser.updateFavourite(
                          context: context, // context bhi pass kiya h because
                          isLiked: isLiked, //because scafoldmsg(context) h isme
                          productId: widget.data.id,
                        );
                      },
                      color: isLiked ? redColor : disabledColor,
                      icon: Icon(
                        isLiked
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
