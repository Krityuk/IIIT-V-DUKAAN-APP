import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:icd_kaa_olx/constants/colors.dart';
import 'package:icd_kaa_olx/firebase_options.dart';
import 'package:icd_kaa_olx/forms/common_form.dart';
import 'package:icd_kaa_olx/forms/user_review_form.dart';
import 'package:icd_kaa_olx/provider/category_provider.dart';
import 'package:icd_kaa_olx/provider/product_provider.dart';
import 'package:icd_kaa_olx/screens/auth/email_verify_screen.dart';
import 'package:icd_kaa_olx/screens/auth/login_screen.dart';
import 'package:icd_kaa_olx/screens/auth/registerscreen.dart';
import 'package:icd_kaa_olx/screens/auth/reset_password_screen.dart';
import 'package:icd_kaa_olx/screens/category/category_list_screen.dart';
import 'package:icd_kaa_olx/screens/category/product_by_category_screen.dart';
import 'package:icd_kaa_olx/screens/chat/chat_screen.dart';
import 'package:icd_kaa_olx/screens/chat/user_chat_screen.dart';
import 'package:icd_kaa_olx/screens/home_screen.dart';
import 'package:icd_kaa_olx/screens/location_screen.dart';
import 'package:icd_kaa_olx/screens/main_navigation_screen.dart';
import 'package:icd_kaa_olx/screens/posts/my_post_screen.dart';
import 'package:icd_kaa_olx/screens/product/product_details_screen.dart';
import 'package:icd_kaa_olx/screens/profile_screen.dart';
import 'package:icd_kaa_olx/screens/splash_screen.dart';
import 'package:icd_kaa_olx/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(//this protects storage from spams and bots
  //   // webRecaptchaSiteKey: 'recaptcha-v3-site-key'
  //   //Replacing 'recaptcha-v3-site-key' with your actual reCAPTCHA v3 site keyis optional
  //   // if i dont create and my own recaptcha key then firebase would be using its default firebase protection
  // );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => CategoryProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // below two lines are for making notch screen to black
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    return MaterialApp(
      title: 'ICD DUKAAN',
      theme: ThemeData(
        primaryColor: blackColor, //appbar,buttons,etc ka color
        backgroundColor: whiteColor, //is property ka use samajh nai aaya
        fontFamily: 'Oswald', // see pubspec.yaml for it
        scaffoldBackgroundColor: whiteColor,
        appBarTheme: AppBarTheme(
          elevation: 4,
          toolbarTextStyle: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 25.0, // Set the font size of the AppBar's title text
              fontWeight: FontWeight.bold,
            ),
          ).bodyMedium,
          titleTextStyle: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white, // Set the color of the AppBar's title text
              fontSize: 24.0, // Set the font size of the AppBar's title text
              fontWeight: FontWeight.bold,
            ),
          ).titleLarge,
        ),
        // har scaffold ka ab white backgound color rhega,
        // vaise by default scaffold background is white colored and texts in scaffold are black
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        //routes na likhe to code me kahi error nai aayega, but firbhi navigator.push work nai krega //i.e.. sare routes main me likhne hi padte h,tabhi navigator.push works
        SplashScreen.screenId: (context) => const SplashScreen(),
        WelcomeScreen.screenId: (context) => const WelcomeScreen(),
        LoginScreen.screenId: (context) => const LoginScreen(),
        RegisterScreen.screenId: (context) => const RegisterScreen(),
        EmailVerifyScreen.screenId: (context) => const EmailVerifyScreen(),
        LocationScreen.screenId: (context) => const LocationScreen(),
        ResetPasswordScreen.screenId: (context) => const ResetPasswordScreen(),
        MainNavigationScreen.screenId: (context) =>
            const MainNavigationScreen(),
        HomeScreen.screenId: (context) => const HomeScreen(),
        CategoryListScreen.screenId: (context) => const CategoryListScreen(),
        ChatScreen.screenId: (context) => const ChatScreen(),
        MyPostScreen.screenId: (context) => const MyPostScreen(),
        ProfileScreen.screenId: (context) => const ProfileScreen(),
        ProductByCategory.screenId: (context) => const ProductByCategory(),
        ProductDetail.screenId: (context) => const ProductDetail(),
        CommonForm.screenId: (context) => const CommonForm(),
        UserFormReview.screenId: (context) => const UserFormReview(),
        UserChatScreen.screenId: (context) => const UserChatScreen(),
      },
      // initialRoute: SplashScreen.screenId,
      home: const SafeArea(child: SplashScreen()),
    );
  }
}
