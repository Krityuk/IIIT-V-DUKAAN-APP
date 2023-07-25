import 'package:flutter/material.dart';

import '../../components/large_heading_widget.dart';
import '../../forms/reset_form.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String screenId = 'reset_password_screen';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LargeHeadingWidget(
                  heading: 'Forgot Password',
                  subHeading:
                      'Enter your email to continue your password reset',
                  headingTextSize: 35,
                  subheadingTextSize: 20,
                  sizeWidget: 0.33,
                  topPadding: 0.1,
                ),
                ResetForm(),
              ]),
        ),
      ),
    );
  }
}
