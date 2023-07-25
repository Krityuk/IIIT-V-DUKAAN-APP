import 'package:flutter/material.dart';

import '../../components/large_heading_widget.dart';
import '../../forms/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const String screenId = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LargeHeadingWidget(
            heading: 'Welcome',
            subHeading: 'Sign In to Continue',
            topPadding: 0.125,
            sizeWidget: 0.33,
          ),
          Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: const LogInForm()),
          ),
        ],
      )),
    );
  }
}
