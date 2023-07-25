import 'package:flutter/material.dart';

Color primaryColor = const Color(0xffA088D5);
Color secondaryColor = const Color(0xff6b37e5);
Color whiteColor = Colors.white;
Color blackColor = Colors.black;
Color? greyColor = Colors.grey[800];
Color disabledColor = Colors.grey;
Color purpleColor = Colors.teal;
Color errorColor = Colors.red;
Color redColor = Colors.red;
Color orangeColor = Colors.orange;
Color pinkColor = Colors.pink;
Color blueGreyColor = Colors.blueGrey;
Color greenColor = Colors.green;
Color amberColor = Colors.amber;
Color blueColor = Colors.blue;
Color myTestingColor = Colors.red; //*******
Color linkColor = const Color.fromARGB(255, 6, 97, 172);

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

void myPrintingFUNCTION(String msg) {
  debugPrint('$msg      😎😎😎😎😎😎😎😎');
}
