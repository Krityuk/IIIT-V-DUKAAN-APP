import 'package:flutter/material.dart';
// import 'package:icd_kaa_olx/screens/welcome_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:open_mail_app/open_mail_app.dart';

import '../../components/custom_icon_button.dart';
import '../../constants/colors.dart';
import '../../constants/widgets.dart';
// import '../location_screen.dart';

class EmailVerifyScreen extends StatefulWidget {
  static const String screenId = 'email_otp_screen';
  const EmailVerifyScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  //
  // bool isPinEntered = false;
  // String smsCode = "";
  // Future<void> validateEmailOtp() async {
  //  debugPrint('sms code is : $smsCode  😎😎😎😎😎😎😎😎');
  // }

  // Auth authService = Auth();

  @override
  Widget build(BuildContext context) {
    // NOTE :
    //Scaffold is wrapped into willPopScope just to override the back button of mobile,
    //we need to override this buttton because i want like on tapping back buttotn it should appear this scaffoldmsg instead of doing back/Navigator.pop
    return WillPopScope(
      onWillPop: () async {
        return customSnackBar(
            context: context,
            content:
                'Please confirm your email address to complete the verification process.');
      },
      child: Scaffold(
        appBar: null,
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: screenHeight(context) * 0.25,
          child: Padding(
            padding:
                EdgeInsets.only(top: screenHeight(context) * 0.1, left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify Email',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Check your email to verify your regsitered email',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 40, right: 40, bottom: 40),
              child: Lottie.asset(
                'assets/lottie/verify_lottie.json',
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
            InkWell(
              onTap: () async {
                debugPrint('Verify button tapped       😎😎😎😎😎😎😎😎');
                var result = await OpenMailApp.openMailApp();
                if (!result.didOpen && !result.canOpen) {
                  // if result.canOpen is true it means apps are available to open msg
                  // if result.didOpen is true means opening done succefully
                  customSnackBar(
                      context: context, content: 'No mail apps installed');
                } else if (!result.didOpen && result.canOpen) {
                  // If result.didOpen is false and result.canOpen is true,
                  // then it means that there are mail apps available but none were opened.
                  showDialog(
                    context: context,
                    //so apps were there but not got opened because there were many mail apps,so we need to decide that which app is to be used=> picker dialog, using the MailAppPickerDialog widget  made. This dialog allows the user to select a mail app from the available options provided in result.options.
                    builder: (_) {
                      return MailAppPickerDialog(
                        mailApps: result.options,
                      );
                    },
                  );
                }
              },
              child: myCustomIconButton(
                  text: 'Verify Email',
                  bgColor: secondaryColor,
                  icon: Icons.verified_user,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
            )
          ]),
        ),
      ],
    );
  }
}
