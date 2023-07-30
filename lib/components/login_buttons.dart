// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/components/custom_icon_button.dart';

import '../constants/colors.dart';
import '../screens/main_navigation_screen.dart';
import '../services/auth.dart';

// NOTE THIS STL WIDGET IS GOOGLE SIGN IN PHONE SIGN IN WALA BUTTON
// NOTE THIS STL WIDGET IS GOOGLE SIGN IN PHONE SIGN IN WALA BUTTON
class LoginInButtons extends StatefulWidget {
  const LoginInButtons({super.key});

  @override
  State<LoginInButtons> createState() => _LoginInButtonsState();
}

class _LoginInButtonsState extends State<LoginInButtons> {
  @override
  Widget build(BuildContext context) {
    Auth myAuthService = Auth();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: whiteColor),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (builder) => const PhoneAuthScreen()));
            },
            child: myCustomIconButton(
              text: 'Sign In with Phone',
              imageIcon: 'assets/icons/phone.png',
              bgColor: greyColor,
              imageOrIconColor: whiteColor,
              imageOrIconRadius: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: whiteColor),
          child: InkWell(
            onTap: () async {
              User? user =
                  await myAuthService.signInWithGoogle(context: context);
              if (user != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MainNavigationScreen.screenId, (route) => false);
              }
            },
            child: myCustomIconButton(
              text: 'Sign In with Google',
              imageIcon: 'assets/icons/google.png',
              bgColor: whiteColor,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
