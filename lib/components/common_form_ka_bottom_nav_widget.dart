import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BottomNavigationWidget extends StatelessWidget {
  //
  final bool validator;
  final Function()? onPressed;
  final String buttonText;

  //
  const BottomNavigationWidget({
    Key? key,
    required this.validator,
    this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: AbsorbPointer(
            absorbing: !validator,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: validator
                      ? MaterialStateProperty.all(secondaryColor)
                      : MaterialStateProperty.all(disabledColor)),
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
