import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icd_kaa_olx/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/widgets.dart';
// ignore: unused_import
import '../services/get_imgurl_from_storage.dart';
import '../services/user.dart';

class ProfileScreen extends StatefulWidget {
  static const screenId = 'profile_screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserService firebaseUser = UserService();
    return Scaffold(
      backgroundColor: blackColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: screenHeight(context) * 0.2),
            Text(
              "${firebaseUser.user!.email} is your 1st account",
              style: TextStyle(color: whiteColor),
            ),
            Text(
              "${firebaseUser.user!.emailVerified} is emailVerified",
              style: TextStyle(color: whiteColor),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(secondaryColor),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 50))),
                onPressed: () async {
                  loadingDialogBox(context, 'Signing Out');

                  //these two both lines are req for google signOut. If you want to sign the user out, you'll need to perform sign-out operations for both Google Sign-In and Firebase Authentication. but only second line in them is req for email signout
                  await GoogleSignIn().signOut();

                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        WelcomeScreen.screenId, (route) => false);
                  });
                },
                child: const Text(
                  'Sign Out',
                )),
            // ElevatedButton(
            //     onPressed: () {
            //       getCategoryImageUrlsFromStorage();
            //     },
            //     child: const Text('debugPrint Storage images')),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ParagraphScreen()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: greenColor),
              child: const Text('Contribute Here  ↓↓'),
            ),
            SizedBox(
              width: 150, // Set the desired width
              height: 150, // Set the desired height
              child: Image.asset(
                  'assets/icons/phonePay.jpg'), // Replace with your image URL
            ),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.white10),
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  // ignore: curly_braces_in_flow_control_structures
                  setState(() {
                    (prefs.getBool('songPresent') != false)
                        ? prefs.setBool('songPresent', false)
                        : prefs.setBool('songPresent', true);
                    log("Hiiiiiii");
                    log("sharedPref is ${prefs.getBool('songPresent')}");
                    log("Hiiiiiii");
                    if (prefs.getBool('songPresent') != false) {
                      customSnackBar(
                          context: context, content: "April Fool Bnaya 🤣");
                    }
                  });
                },
                child: const Text('Hidden')),

            SizedBox(height: screenHeight(context) * 0.1),
          ],
        ),
      ),
    );
  }
}

// paragraph_screen.dart

class ParagraphScreen extends StatelessWidget {
  const ParagraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: const Text('Contribute Here'),
        backgroundColor: blackColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Welcome to our wonderful community! Your contributions of some like 10 or 20 Rs, are the heartbeat of this app and it would be used to enhance this app for our campus.You are requested to pay a very small just like 10 or 20Rs or more here.\nTo launch this app on PlayStore we spent 25 dollers from our pocket. We did it for our campus. You can also contribute a small kind one. \n\n',
                style: TextStyle(fontSize: 18, color: whiteColor),
              ),
              SizedBox(
                width: 150, // Set the desired width
                height: 150, // Set the desired height
                child: Image.asset(
                    'assets/icons/phonePay.jpg'), // Replace with your image URL
              ),
              Text(
                '\n\nThis money will be used for making this app more and more better.',
                style: TextStyle(color: amberColor),
              ),
              Text(
                '\nWith every contribution, you inspire us to strive for greatness, and we promise to use your kindness wisely to enhance the app\'s features and enrich the user experience.\n\nTogether, we build not just an app, but a bridge of love and support, connecting us all on this incredible journey. Your generosity empowers us to reach new heights, and for that, we are eternally grateful.\n\nThank you for being the heart of our app, beating with love, kindness, and the belief that together, we can make a difference. Let\'s continue this beautiful journey of creating something extraordinary and touching lives across the world \n\n',
                style: TextStyle(fontSize: 18, color: whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
