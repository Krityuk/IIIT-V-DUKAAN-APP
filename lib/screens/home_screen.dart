import 'package:cached_network_image/cached_network_image.dart'; //The cached_network_image package in Flutter is used for efficiently loading and caching images,this package is also used in only adv wala widget
import 'package:carousel_slider/carousel_slider.dart'; //carousel_slider is for image animation in advertisement images here
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:icd_kaa_olx/screens/category/category_widget.dart';
import 'package:icd_kaa_olx/screens/location_screen.dart';
import 'package:icd_kaa_olx/services/user.dart';

import '../components/main_appbar_with_search.dart';
import '../components/product_listing_widget.dart';
import '../constants/colors.dart';
import '../constants/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const String screenId = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  late TextEditingController searchController;
  late FocusNode searchNode;
  //TextEditingController and FocusNode are created to manage the search button of the app
  //

  Future<List<String>> downloadBannerImageUrlList() async {
    List<String> bannerUrlList = [];
    final ListResult storageRef =
        await FirebaseStorage.instance.ref().child('banner').listAll();
    List<Reference> bannerRef = storageRef.items;
    await Future.forEach<Reference>(bannerRef, (image) async {
      final String fileUrl = await image.getDownloadURL();
      bannerUrlList.add(fileUrl);
    });
    return bannerUrlList;
  }

  @override
  void initState() {
    searchController = TextEditingController();
    searchNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 0.1),
          child: MainAppBarWithSearch(
              controller: searchController, focusNode: searchNode),
        ),
        body: homeBodyWidget(),
      ),
    );
  }

//*********************************************************************** */
//*********************************************************************** */

  Widget homeBodyWidget() {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, //col taking min size in its parent
          children: [
            Container(
              color: disabledColor.withOpacity(0.5),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 50,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(LocationScreen.screenId);
                },
                child: Center(child: widgetLcoationAutoFetchBar(context)),
              ),
            ),
            //************************************************ */
            Container(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  //************************************************ */
                  const CategoryWidget(),
                  //************************************************ */
                  FutureBuilder(
                    future: downloadBannerImageUrlList(),
                    //this func returns list of img urls
                    //future me bas ek func dalte h jo ki kuchh return krta ho,us returned item ko snapshot bolenge like agar koi list return kiya ya koi object return kiya,
                    //fir snapshot[index] for list and snapshot.mobile krke unko use kr pate h
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: screenHeight(context) * 0.22,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: secondaryColor,
                          )),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return SizedBox(
                            height: screenHeight(context) * 0.22,
                            child: const Center(
                              child: Text('Facing issue in banner loading'),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: CarouselSlider.builder(
                              itemCount: snapshot.data!.length,
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayCurve: Curves.bounceOut,
                                viewportFraction: 0.95,
                                enlargeCenterPage: true,
                                // Make the current slide larger
                                aspectRatio: 16 / 9,
                                // Set the aspect ratio of the slide
                              ),
                              itemBuilder: (context, index, realIdx) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    imageUrl: snapshot.data![index],
                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),
                  //************************************************ */
                ],
              ),
            ),
            const ProductListing()
          ],
        ),
      ),
    );
  }

  // BECHDAL word ke neeche ka container hai ye jisme ki icon.pin bna hua tha vo container
  widgetLcoationAutoFetchBar(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(), //future: currentUser ka snapshot dala
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return customSnackBar(
              context: context, content: "Something went wrong");
        } else if (snapshot.hasData && !snapshot.data!.exists) {
          return customSnackBar(
              context: context, content: "Addrress not selected");
        } else if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['address'] == null) {
            //NOTE data['address'] == null means, address naam ki koi field ni h snapshot me
            //
            // Position? position = data['location'];//IF ADDRESS IS NULL THEN YE KHUD SE FETCH KR LEGA ADDRESS HERE USING GOOGLE MAPS CONCEPT,I AM NOT MAKING THIS feature CURRENTLY in this app
            // getFetchedAddress(context, position).then((location) {
            return const LocationTextWidget(
              location: 'FILL LOCATION HERE',
              mobile: '',
            );
            // });
          } else {
            // if address field is present there then this got returned
            return LocationTextWidget(
              location: data['address'],
              mobile: data['mobile'],
            );
          }
        } else {
          return const LocationTextWidget(
            location: 'FILL LOCATION HERE',
            mobile: '',
          );
        }
      },
    );
  }
}

class LocationTextWidget extends StatelessWidget {
  final String? location;
  final String? mobile;
  //yaha String? use kiiya for safety ki upar if-else me maan lo by chance koi case chhut gya ho if else me and then location aaya hi na ho uske liye bas
  const LocationTextWidget(
      {Key? key, required this.location, required this.mobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserService firebaseUser = UserService();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.pin_drop,
          size: 22,
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          location ?? 'FILL LOCATION ',
          //yaha String? use kiya for safety ki upar if-else me maan lo by chance koi case chhut gya ho if else me and then location aaya hi na ho uske liye bas
          // waise ICD ka olx app me iski jroorat nai h kyuki location ki jgh sirf room no use kr rhe, may begeolocator would return null String
          style: TextStyle(
            color: whiteColor,
            fontFamily: 'Times',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          mobile ?? '',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        //if displayName is not null means its google signiN registered, else it means here email signIn
        if (firebaseUser.user!.displayName != null)
          Expanded(
            child: Container(
                alignment: Alignment.centerRight,
                height: 38,
                child: Image.asset(
                  'assets/icons/google.png',
                )),
          ),
      ],
    );
  }
}
