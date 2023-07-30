import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/components/custom_icon_button.dart';

import '../constants/colors.dart';
import '../screens/main_navigation_screen.dart';
import '../services/auth.dart';

class SignUpButtons extends StatefulWidget {
  const SignUpButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpButtons> createState() => _SignUpButtonsState();
}

class _SignUpButtonsState extends State<SignUpButtons> {
  Auth myAuthService = Auth();
  // NOTE signUp page and SignIn page ke neeche me jo do buttons the, (signIn with google and signIn wieth phoned) ye signUPButtons.dart unhi ka widget hai
  @override
  Widget build(BuildContext context) {
    return Column(
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
              //         builder: (builder) => const PhoneAuthScreen(
              //               isFromLogin: false,
              //             )));
            },
            child: myCustomIconButton(
              text: 'Signup with Phone',
              imageIcon: 'assets/icons/phone.png',
              bgColor: greyColor,
              imageOrIconColor: whiteColor,
              imageOrIconRadius: 20,
            ),
          ),
        ),
//******************************************************************************************* */
        const SizedBox(
          height: 10,
        ),
//******************************************************************************************* */
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: whiteColor),
          margin: const EdgeInsets.symmetric(horizontal: 30),
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
              text: 'Signup with Google',
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
