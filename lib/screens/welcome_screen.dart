import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:icd_kaa_olx/screens/auth/login_screen.dart';
import 'package:icd_kaa_olx/screens/auth/registerscreen.dart';
import '../constants/colors.dart';
import '../constants/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  static const screenId = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          SizedBox(
            width: double.infinity,
            height: screenHeight(context) * 0.27,
            child: Padding(
              padding:
                  EdgeInsets.only(top: screenHeight(context) * 0.1, left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      'ICD DUKAAN💰💰',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Sell your un-needs here',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Lottie.asset(
                'assets/lottie/welcome_lottie.json',
                width: double.infinity,
                height: screenHeight(context) * 0.47,
              ),
            ),
          ),
          //
          _bottomWidget(context),
        ],
      ),
    );
  }

//******************************************************************************** */
//******************************************************************************** */
  Widget _bottomWidget(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: myRoundedButton(
              context: context,
              bgColor: whiteColor,
              borderColor: blackColor,
              textColor: blackColor,
              text: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.screenId);
              }),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: myRoundedButton(
              context: context,
              bgColor: secondaryColor,
              text: 'Sign Up',
              textColor: whiteColor,
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.screenId);
              }),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
