// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../constants/colors.dart';

class myCustomIconButton extends StatelessWidget {
  final String? text;
  final String? imageIcon;
  final IconData? icon;
  final Color? imageOrIconColor;
  final double? imageOrIconRadius;
  final Color? bgColor;
  final EdgeInsets? padding;
  const myCustomIconButton({
    Key? key,
    this.text,
    this.imageIcon,
    this.icon,
    this.imageOrIconColor,
    this.imageOrIconRadius,
    this.bgColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: bgColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageIcon != null
                    ? Container(
                        height: 25,
                        margin: const EdgeInsets.only(left: 20),
                        child: Image.asset(
                          imageIcon!,
                          color: imageOrIconColor,
                          height: imageOrIconRadius,
                          width: imageOrIconRadius,
                        ))
                    : Container(),
                icon != null // sign in page has not sent icon, unme ':null' aayega
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          icon,
                          size: imageOrIconRadius,
                          color: imageOrIconColor ?? whiteColor,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  width: 10,
                ),
                text != null
                    ? Container(
                        alignment: Alignment.center,
                        child: Text(
                          text!,
                          style: TextStyle(
                            color: (bgColor == whiteColor)
                                ? blackColor
                                : whiteColor,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ));
  }
}
