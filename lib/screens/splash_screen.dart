import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/screens/main_navigation_screen.dart';
// import 'package:lottie/lottie.dart';

import 'package:icd_kaa_olx/screens/welcome_screen.dart';
import '../constants/colors.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class SplashScreen extends StatefulWidget {
  static const String screenId = 'splash_screen'; //this line

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    permissionBasedNavigationFunc();
    super.initState();
    _playSong();
  }

  void _playSong() async {
    try {
      await assetsAudioPlayer.open(Audio('assets/gif/clg.mp3'));
      debugPrint('PLaying song       😎😎😎😎😎😎😎😎');
    } catch (e) {
      debugPrint('NOT NOT Playing       😎😎😎😎😎😎😎😎');
      debugPrint(e.toString());
    }
  }

  permissionBasedNavigationFunc() {
    Timer(const Duration(seconds: 6), () async {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.screenId);
        } else {
          Navigator.pushReplacementNamed(
              context, MainNavigationScreen.screenId);
        }
      });
    });
  }

  @override // no need of this func here because no extra codes we want during dispose
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/gif/clg.gif',
                fit: BoxFit.fill,
              )
              // child: Lottie.asset(
              //   "assets/lottie/splash_lottie.json",
              // ),
              ),
          Container(
            width: screenWidth(context), //screenHeight func is made by me
            margin: EdgeInsets.only(top: screenHeight(context) * 0.32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ICD DUKAAN',
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                Text(
                  'Sell your un-needs here !',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
