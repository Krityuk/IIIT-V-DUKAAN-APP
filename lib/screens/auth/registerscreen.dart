import 'package:flutter/material.dart';

import '../../components/large_heading_widget.dart';
import '../../constants/colors.dart';
import '../../forms/register_form.dart';

class RegisterScreen extends StatefulWidget {
  static const screenId = '/register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: _body(),
    );
  }
}

_body() {
  return SingleChildScrollView(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: LargeHeadingWidget(
          heading: 'Create Account',
          subHeading: 'Enter your Name, Email and Password for sign up.',
          anotherTaglineText: '\nAlready have an account ?',
          anotherTaglineColor: secondaryColor,
          subheadingTextSize: 16,
          taglineNavigation: true, // easy
          sizeWidget: 0.25,
          topPadding: 0.075,
        ),
      ),
      Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const RegisterForm()),
      ),
    ]),
  );
}
