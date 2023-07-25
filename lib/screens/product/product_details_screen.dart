import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/constants/widgets.dart';
import 'package:icd_kaa_olx/services/get_imgurl_from_storage.dart';
import 'package:intl/intl.dart';
// import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../provider/product_provider.dart';
import '../../services/auth.dart';
import '../../services/user.dart';
import '../chat/user_chat_screen.dart';

class ProductDetail extends StatefulWidget {
  static const screenId = 'product_details_screen';
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // late GoogleMapController _mapController;
  Auth authService = Auth();
  UserService firebaseUser = UserService();
  bool _loading = true;
  int _index = 0;
  bool isLiked = false;
  List fav = []; //this list would store those uids who have liked this product
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

//*************************************************************************** */
  @override
  void didChangeDependencies() {
    var productProvider = Provider.of<ProductProvider>(context);
    getFavourites(productProvider: productProvider);
    super.didChangeDependencies();
  }

  getFavourites({required ProductProvider productProvider}) {
    authService.products
        .doc(productProvider.productData!.id)
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          fav = value['favourites'];
        });
      }
      if (fav.contains(firebaseUser.user!.uid)) {
        if (mounted) {
          setState(() {
            isLiked = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLiked = false;
          });
        }
      }
    });
  }
//*************************************************************************** */

  // _mapLauncher(location) async {
  //   final availableMaps = await launcher.MapLauncher.installedMaps;
  //   await availableMaps.first.showMarker(
  //     coords: launcher.Coords(location.latitude, location.longitude),
  //     title: "Seller Location is here..",
  //   );
  // }

  Future<void> _callLauncher(phoneNo) async {
    if (!await launchUrl(phoneNo)) {
      throw 'Could not launch $phoneNo';
    }
  }

  _createChatRoom(ProductProvider productProvider) {
    // here tin thingd bna rhe,
    Map productDetals = {
      'product_id': productProvider.productData!.id,
      'product_img': productProvider.productData!['images'][0],
      'price': productProvider.productData!['price'],
      'title': productProvider.productData!['title'],
      'seller': productProvider.productData!['seller_uid'],
    };
    List<String> users = [
      productProvider.sellerDetails!['uid'],
      firebaseUser.user!.uid,
    ];
    String chatroomId =
        '${productProvider.sellerDetails!['uid']}.${firebaseUser.user!.uid}${productProvider.productData!.id}';
    Map<String, dynamic> chatData = {
      'productDetails': productDetals,
      'users': users,
      'chatroomId': chatroomId,
      'read': false,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch,
    };
    //BELOW line would just create a new document in collection 'messages' that's it
    firebaseUser.createChatRoom(data: chatData);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => UserChatScreen(
                  chatroomId: chatroomId,
                )));
  }

//
//************************************************************************************************* */
  _body({
    required DocumentSnapshot<Object?> data,
    required String formattedDate,
    required ProductProvider productProvider,
    required String formattedPrice,
    // required GeoPoint location,
    required NumberFormat numberFormat,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 450,
                      color: Colors.transparent,
                      child: _loading
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: secondaryColor,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Loading..',
                                  )
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                Center(
                                  child: Image.network(
                                    data['images'][_index],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: 80,
                                    color: whiteColor,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.builder(
                                          physics: const ScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: data['images'].length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _index = index;
                                                });
                                              },
                                              child: Container(
                                                width: 90,
                                                color: disabledColor
                                                    .withOpacity(0.3),
                                                child: Image.network(
                                                    data['images'][index]),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                    //**************************************************************************** */
                    if (_loading == false)
                      //this is shown after 2 sec as _loading becomng false after 2 s in initState
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data['title'].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '₹ $formattedPrice',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data['descr']),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 10,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: disabledColor.withOpacity(0.3),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Posted At: $formattedDate',
                                              style: TextStyle(
                                                color: blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //
                            Divider(
                              color: blackColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 40,
                                  child: CircleAvatar(
                                    backgroundColor: secondaryColor,
                                    radius: 37,
                                    child: Icon(
                                      CupertinoIcons.person,
                                      color: whiteColor,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      productProvider.sellerDetails!['name']
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    subtitle: Text(
                                      'View Profile',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: linkColor,
                                      ),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: linkColor,
                                          size: 12,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(
                              color: blackColor,
                            ),
                            const Text(
                              'Ad Post at:',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 200,
                              color: disabledColor.withOpacity(0.3),
                              child: Stack(
                                children: [
                                  // Center(
                                  //   child: GoogleMap(
                                  //     initialCameraPosition: CameraPosition(
                                  //       zoom: 15,
                                  //       target: LatLng(
                                  //         location.latitude,
                                  //         location.longitude,
                                  //       ),
                                  //     ),
                                  //     mapType: MapType.normal,
                                  //     onMapCreated:
                                  //         (GoogleMapController controller) {
                                  //       setState(() {
                                  //         _mapController = controller;
                                  //       });
                                  //     },
                                  //   ),
                                  // ),
                                  const Center(
                                      child: Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 35,
                                  )),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor:
                                          blackColor.withOpacity(0.1),
                                    ),
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Material(
                                      elevation: 4,
                                      shape: Border.all(
                                          color:
                                              disabledColor.withOpacity(0.2)),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.alt_route_outlined,
                                        ),
                                        onPressed: () async {
                                          // await _mapLauncher(location);
                                          //// ***************************************************************
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ad Id: ${data['posted_at']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Map<String, dynamic> newReportData = {
                                      'uid': productProvider.sellerDetails!.id,
                                      'name': productProvider
                                          .sellerDetails!['name'],
                                      'email': productProvider
                                          .sellerDetails!['email'],
                                      'mobile': productProvider
                                              .sellerDetails!['mobile'] ??
                                          'NOT AVAILABLE',
                                      'timestamp': FieldValue.serverTimestamp(),
                                      'whoHasReportedKaEmail':
                                          firebaseUser.user!.email,
                                      'whoHasReportedKaUid':
                                          firebaseUser.user!.uid
                                    };

                                    myAuthService.usersWhoAreReported
                                        .add(newReportData)
                                        .then((value) => customSnackBar(
                                            context: context,
                                            content: 'Reported Successfully'))
                                        .catchError((error) {
                                      customSnackBar(
                                          context: context,
                                          content:
                                              "Some Prob here, unable to report $error");
                                    });
                                  },
                                  child: Text(
                                    'REPORT AD',
                                    style: TextStyle(color: linkColor),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    //**************************************************************************** */
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

//************************************************************************************************* */
  _bottomWidget({required ProductProvider productProvider}) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: (productProvider.productData!['seller_uid'] ==
                firebaseUser.user!.uid)
            ? myDeleteButton(
                productProvider) //if seller & purchaser are same then showing delete this item button, else showing chat&call buttons
            : Row(children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(secondaryColor)),
                      onPressed: () {
                        _createChatRoom(productProvider);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble,
                              size: 16,
                              color: whiteColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Chat',
                            )
                          ],
                        ),
                      )),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(secondaryColor)),
                      onPressed: () async {
                        var phoneNo = Uri.parse(
                            'tel:${productProvider.sellerDetails!['mobile']}');
                        await _callLauncher(phoneNo);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call,
                              size: 16,
                              color: whiteColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Call',
                            )
                          ],
                        ),
                      )),
                )
              ]),
      ),
    );
  }

//************************************************************************************************* */
  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    final numberFormat = NumberFormat('##,##,##0');
    var data = productProvider.productData;
    //
    var price = int.parse(data!['price']);
    var formattedPrice = numberFormat.format(price);
    //
    var date = DateTime.fromMicrosecondsSinceEpoch(data['posted_at']);
    var formattedDate = DateFormat.yMMMd().format(date);
    // GeoPoint location = productProvider.sellerDetails!['location'];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          iconTheme: IconThemeData(color: blackColor),
          title: Text(
            'Product Details',
            style: TextStyle(color: blackColor),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.share_outlined,
                color: blackColor,
              ),
              onPressed: () {},
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                  firebaseUser.updateFavourite(
                    context: context,
                    isLiked: isLiked,
                    productId: data.id,
                  );
                },
                color: isLiked ? secondaryColor : disabledColor,
                icon: Icon(
                  isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                ))
          ],
        ),
        body: _body(
            data: data,
            formattedDate: formattedDate,
            productProvider: productProvider,
            formattedPrice: formattedPrice,
            // location: location,
            numberFormat: numberFormat),
        bottomSheet:
            _loading ? null : _bottomWidget(productProvider: productProvider));
  }

  deleteItemDialog(ProductProvider productProvider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure, you want to delete this product?',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            secondaryColor,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            secondaryColor,
                          ),
                        ),
                        onPressed: () async {
                          loadingDialogBox(context, 'Deleting this product');
                          await _deleteProduct(productProvider);
                        },
                        child: const Text(
                          'Confirm',
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget myDeleteButton(ProductProvider productProvider) {
    return Expanded(
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(secondaryColor)),
          onPressed: () async {
            await deleteItemDialog(productProvider);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  size: 16,
                  color: redColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Delete',
                )
              ],
            ),
          )),
    );
  }

  _deleteProduct(ProductProvider productProvider) async {
    await myAuthService.products
        .doc(productProvider.productData!.id)
        .update({'isDeleted': true}).then((_) {
      // Update successful
      customSnackBar(context: context, content: 'Deleted successfully');
      Navigator.of(context).pop(); //pop loadingBOx
      Navigator.of(context).pop(); // pop productDetailed screen
      // Handle any additional logic or UI changes
    }).catchError((error) {
      // Handle the error
      // Display an error message or perform error handling
      customSnackBar(
          context: context, content: 'Not Deleted Reason-> ${error.toString}');
    });
  }
}
