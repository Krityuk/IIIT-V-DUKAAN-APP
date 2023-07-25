import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../screens/auth/login_screen.dart';

class LargeHeadingWidget extends StatefulWidget {
  final String heading;
  final double? headingTextSize;
  final Color? headingTextColor;
  final String subHeading;
  final double? subheadingTextSize;
  final Color? subheadingTextColor;
  final String? anotherTaglineText;
  final Color? anotherTaglineColor;
  final bool? taglineNavigation;
  final num topPadding;
  final num sizeWidget;

  const LargeHeadingWidget({
    Key? key, // har stf ya stl me key? key, super(key: key);to hota hi h
    required this.heading,
    required this.subHeading,
    required this.topPadding,
    required this.sizeWidget,
    this.subheadingTextSize,
    this.headingTextSize,
    this.subheadingTextColor,
    this.headingTextColor,
    this.anotherTaglineText,
    this.anotherTaglineColor,
    this.taglineNavigation,
  }) : super(key: key);

  @override
  State<LargeHeadingWidget> createState() => _LargeHeadingWidgetState();
}

class _LargeHeadingWidgetState extends State<LargeHeadingWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) * widget.sizeWidget,
      child: Padding(
        padding:
            EdgeInsets.only(top: screenHeight(context) * widget.topPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                widget.heading,
                style: TextStyle(
                    color: widget.headingTextColor ?? blackColor,
                    fontSize: widget.headingTextSize ?? 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: RichText(
                text: TextSpan(
                    text: widget.subHeading,
                    style: TextStyle(
                      fontFamily: 'Oswald', //RichText does not inherit fonts
                      color: widget.subheadingTextColor ?? greyColor,
                      fontSize: widget.subheadingTextSize ?? 25,
                    ),
                    children: [
                      //BELOW 10 LINES OF CODE ARE for SIGN IN PAGE ONLY(NOT FOR SIGN UP PAGE), as signIn page has anotherTaglineText!=null
                      //YE Already have an account wala part hai
                      widget.anotherTaglineText != null
                          ? TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.taglineNavigation != null
                                    //..onTap se mat daro, 'recogniser.onTap' ki jgh '..onTap' likhte h bas see below commented example for details
                                    // TapGestureRecog ka yahi syntax ab use krna
                                    ? () {
                                        Navigator.pushReplacementNamed(
                                            context, LoginScreen.screenId);
                                      }
                                    : () {},
                              text: widget.anotherTaglineText,
                              style: TextStyle(
                                color: widget.anotherTaglineColor ?? greyColor,
                                fontSize: widget.subheadingTextSize ?? 25,
                              ),
                            )
                          : const TextSpan(), //this line returning null
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Person person = Person();
// person.name = 'John';
// person.age = 25;// THIS IS REPLACED BY BELOW ONE ..onTap property jaisa h
// person.sayHello();

// Person person = Person()
//   ..name = 'John'
//   ..age = 25
//   ..sayHello();
