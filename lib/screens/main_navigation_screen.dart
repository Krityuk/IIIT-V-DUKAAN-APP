import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/screens/category/category_list_screen.dart';
import 'package:icd_kaa_olx/screens/chat/chat_screen.dart';
import 'package:icd_kaa_olx/screens/home_screen.dart';
import 'package:icd_kaa_olx/screens/posts/my_post_screen.dart';
import 'package:icd_kaa_olx/screens/profile_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

import '../constants/colors.dart';

class MainNavigationScreen extends StatefulWidget {
  static const screenId = 'main_nav_screen';
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  List pages = [
    const HomeScreen(),
    const ChatScreen(),
    const CategoryListScreen(isForForm: true),
    //isForForm:true means ki formScreen pr bhejna hai na ki ProductScreenPe
    const MyPostScreen(),
    const ProfileScreen(),
  ];
  PageController controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: PageView.builder(
            itemCount: pages.length,
            controller: controller,
            onPageChanged: (page) {
              setState(() {
                _index = page;
              });
            },
            itemBuilder: (context, index) {
              return pages[index];
            }),
        bottomNavigationBar: kIsWeb
            ? _bottomNavigationBar()
            : FittedBox(child: _bottomNavigationBar()));
    // android me fitted box diya but web me fitted box nai diya kyuki isse bottom nav bar boht bada ho ja rha tha in web
  }
//NOTE "import 'package:dot_navigation_bar/dot_navigation_bar.dart';" USED HERE
//THAT IS  DotNavigationBar and PAgeView.Builder is used here
// AND these two are connected via setState of DotNavigationBar

  Widget _bottomNavigationBar() {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: DotNavigationBar(
        backgroundColor: blackColor,
        margin: EdgeInsets.zero,
        paddingR: EdgeInsets.zero,
        selectedItemColor: secondaryColor,
        currentIndex: _index,
        dotIndicatorColor: Colors.transparent,
        unselectedItemColor: disabledColor,
        enablePaddingAnimation: true,
        enableFloatingNavBar: false,
        onTap: (index) {
          setState(() {
            _index = index;
          });
          controller.jumpToPage(index);
        },
        items: [
          DotNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 0 ? whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(
                _index == 0 ? CupertinoIcons.house_fill : CupertinoIcons.home,
                color: _index == 0 ? purpleColor : disabledColor,
                size: 30,
              ),
            ),
          ),
          DotNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 1 ? whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(
                _index == 1 ? Icons.chat : Icons.chat_outlined,
                color: _index == 1 ? purpleColor : disabledColor,
              ),
            ),
          ),
          DotNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 2 ? whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(
                size: 30,
                Icons.add,
                color: _index == 2 ? purpleColor : disabledColor,
              ),
            ),
          ),
          DotNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 3 ? whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(
                CupertinoIcons.photo_camera_solid,
                color: _index == 3 ? purpleColor : disabledColor,
              ),
            ),
          ),
          DotNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 4 ? whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(
                CupertinoIcons.person_alt,
                color: _index == 4 ? purpleColor : disabledColor,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
