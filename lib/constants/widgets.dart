import 'package:flutter/material.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

import 'package:icd_kaa_olx/constants/colors.dart';

import '../modals/pop_up_menu_modal.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../services/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

//
loadingDialogBox(BuildContext context, String loadingMessage) {
  AlertDialog alertBox = AlertDialog(
    content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularProgressIndicator(
            color: secondaryColor,
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            loadingMessage,
            style: TextStyle(
              color: blackColor,
            ),
          )
        ]),
  );

  showDialog(
      barrierDismissible: false,
      // barrierDismissible parameter to control whether the dialog can be dismissed by tapping outside of it. Setting barrierDismissible to false means that the user cannot dismiss the dialog in this manner.
      context: context,
      // The context parameter refers to the current BuildContext in which the dialog should be displayed.
      builder: (BuildContext context) {
        return alertBox;
      });
}

wrongDetailsAlertBox(String text, BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Text(
      text,
      style: TextStyle(
        color: blackColor,
      ),
    ),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Ok',
          )),
    ],
  );

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

//
Widget myRoundedButton({
  context,
  required Color? bgColor,
  required Function()? onPressed,
  Color? textColor,
  double? width,
  double? heightPadding,
  required String? text,
  Color? borderColor,
}) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: SizedBox(
        width: width ?? double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(
                    color: borderColor ?? secondaryColor,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(bgColor)),
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: heightPadding ?? 15),
            child: Text(
              text!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

customSnackBar({required BuildContext context, required String content}) {
  // return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   backgroundColor: blackColor,
  //   content: Text(
  //     content,
  //     style: TextStyle(color: whiteColor, letterSpacing: 0.5),
  //   ),
  // ));
  myShowToast(message: content, textColor: whiteColor);
}

void myShowToast({required message, Color? textColor}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 4,
    backgroundColor: Colors.pink,
    textColor: textColor ?? Colors.white,
    fontSize: 16.0,
  );
}

openBottomSheetWidget(
    {required BuildContext context,
    required Widget child,
    String? appBarTitle, //appBarTilte is for searchButton of mainNavigationPage
    double? height}) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(10),
                      ),
                      child: Icon(Icons.close, color: blackColor),
                    ),
                  ),
                ],
              ),
              //********************************************************************************* */
              // if (appBarTitle != null)
              //   Container(
              //     color: Colors.transparent,
              //     child: AppBar(
              //       automaticallyImplyLeading: false,
              //       backgroundColor: secondaryColor,
              //       title: Text(
              //         appBarTitle,
              //         style: TextStyle(color: whiteColor, fontSize: 18),
              //       ),
              //     ),
              //   ),
              //********************************************************************************* */
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight:
                            height ?? MediaQuery.of(context).size.height / 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

//******************************************************************************************** */
// THIS CUSTOMPOPUPMENU WIDGET IS THE THREE DOTS BUTTON OF USER CHAT SCREEN andchat_card widget,(dono me detto same hai)
threeDotsButton({
  required BuildContext context,
  required String? chatroomId,
  bool? isWhiteColored,
}) {
  CustomPopupMenuController controller = CustomPopupMenuController();
  UserService firebaseUser = UserService();
  List<PopUpMenuModel> menuItems = [
    PopUpMenuModel('Delete', Icons.delete),
    // PopUpMenuModel('Mark Sold', Icons.done),
  ];
  return CustomPopupMenu(
    menuBuilder: () => ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: whiteColor,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: menuItems
                .map(
                  (item) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (menuItems.indexOf(item) == 0) {
                        firebaseUser.deleteChat(chatroomId: chatroomId);
                        customSnackBar(
                            context: context,
                            content: 'Chat successfully deleted..');
                        if (isWhiteColored == null) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              MainNavigationScreen.screenId, (route) => false);
                        }
                      }
                      // if (menuItems.indexOf(item) == 1) {
                      //   debugPrint('Mark Sold');
                      // }
                      controller.hideMenu(); //hide popUpMenu
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            item.icon,
                            size: 15,
                            color: redColor,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ),
    pressType: PressType.singleClick,
    verticalMargin: -10,
    controller: controller,
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Icon(Icons.more_vert_sharp,
          color: (isWhiteColored == null) ? blackColor : whiteColor),
    ),
  );
}
