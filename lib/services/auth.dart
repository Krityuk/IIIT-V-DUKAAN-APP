import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icd_kaa_olx/screens/main_navigation_screen.dart';

import '../constants/widgets.dart';
import '../screens/auth/email_verify_screen.dart';

Future<bool> isEmailExists(String email) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('users')
      .where('email', isEqualTo: email)
      .limit(1)
      .get(); //choose that snapshots in which email=ye wala email;

  return snapshot.docs.isNotEmpty;
}

class Auth {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();
  User? currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  CollectionReference usersWhoAreReported =
      FirebaseFirestore.instance.collection('users_whoAreReported');

  // NOTE:
  // Future<void> getAdminCredentialPhoneNumber(BuildContext context, user) async {
  //   final QuerySnapshot userDataQuery =
  //       await users.where('uid', isEqualTo: user!.uid).get();
  //   List<DocumentSnapshot> wasUserPresentInDatabase = userDataQuery.docs;
  //   if (wasUserPresentInDatabase.isNotEmpty) {
  //     Navigator.pushReplacementNamed(context, LocationScreen.screenId);
  //   } else {
  //     await registerWithPhoneNumber(user, context);
  //   }
  // }

  // Future<void> registerWithPhoneNumber(user, context) async {
  //   final uid = user!.uid;
  //   final mobileNo = user!.phoneNumber;
  //   final email = user!.email;
  //   Navigator.pushReplacementNamed(context, LocationScreen.screenId);
  //   return users.doc(uid).set({
  //     'uid': uid,
  //     'mobile': mobileNo,
  //     'email': email,
  //     'name': '',
  //     'address': ''
  //   }).then((value) {
  //     if (kDebugMode) {
  //       print('user added successfully');
  //     }
  //     // ignore: invalid_return_type_for_catch_error, avoid_print
  //   }).catchError((error) => print("Failed to add user: $error"));
  // }

  // Future<void> verifyPhoneNumber(BuildContext context, number) async {
  //   loadingDialogBox(context, 'Please wait');

  //   // ignore: prefer_function_declarations_over_variables
  //   final PhoneVerificationCompleted verificationCompleted =
  //       (phoneAuthCredential) async {
  //     await _firebaseAuth.signInWithCredential(phoneAuthCredential);
  //   };

  //   // ignore: prefer_function_declarations_over_variables
  //   final PhoneVerificationFailed verificationFailed =
  //       (FirebaseAuthException e) {
  //     if (e.code == 'invalid-phone-number') {
  //       Navigator.pop(context);
  //       wrongDetailsAlertBox(
  //           'The phone number that you entered is invalid. Please enter a valid phone number.',
  //           context);
  //     } else {
  //       Navigator.pop(context);
  //       wrongDetailsAlertBox(e.code, context);
  //     }
  //   };
  //   final PhoneCodeSent phoneCodeSent =
  //       ((verificationId, forceResendingToken) async {
  //     Navigator.pop(context);
  // Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (builder) => PhoneOTPScreen(
  //               phoneNumber: number,
  //               verificationIdFinal: verificationId,
  //             )));
  //   });
  //   try {
  //     _firebaseAuth.verifyPhoneNumber(
  //         phoneNumber: number,
  //         verificationCompleted: verificationCompleted,
  //         verificationFailed: verificationFailed,
  //         timeout: const Duration(seconds: 60),
  //         codeSent: phoneCodeSent,
  //         codeAutoRetrievalTimeout: (String verificationId) {
  //           print(verificationId);
  //         });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //   }
  // }

  // Future<void> signInwithPhoneNumber(
  //     String verificationId, String smsCode, BuildContext context) async {
  //   try {
  //     loadingDialogBox(context, 'Please Wait');
  //     AuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId, smsCode: smsCode);

  //     UserCredential userCredential =
  //         await _firebaseAuth.signInWithCredential(credential);

  //     Navigator.pop(context);
  //     if (userCredential != null) {
  //       getAdminCredentialPhoneNumber(context, userCredential.user);
  //     } else {
  //       wrongDetailsAlertBox('Login Failed, Please retry again.', context);
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     wrongDetailsAlertBox(
  //         'The details you entered is not matching with our database. Please validate details again, before proceeding. ',
  //         context);
  //   }
  // }
  // NOTE:
  // static Future<User?> signInWithGoogle({required BuildContext context}) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user;

  //   if (kIsWeb) {
  //     GoogleAuthProvider authProvider = GoogleAuthProvider();

  //     try {
  //       final UserCredential userCredential =
  //           await auth.signInWithPopup(authProvider);

  //       user = userCredential.user;
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }
  //   } else {
  //     final GoogleSignIn googleSignIn = GoogleSignIn();

  //     final GoogleSignInAccount? googleSignInAccount =
  //         await googleSignIn.signIn();

  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //           await googleSignInAccount.authentication;

  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );

  //       try {
  //         final UserCredential userCredential =
  //             await auth.signInWithCredential(credential);

  //         user = userCredential.user;
  //       } on FirebaseAuthException catch (e) {
  //         if (e.code == 'account-exists-with-different-credential') {
  //           customSnackBar(
  //             context: context,
  //             content: 'The account already exists with a different credential',
  //           );
  //         } else if (e.code == 'invalid-credential') {
  //           customSnackBar(
  //             context: context,
  //             content: 'Error occurred while accessing credentials. Try again.',
  //           );
  //         }
  //       } catch (e) {
  //         customSnackBar(
  //           context: context,
  //           content: 'Error occurred using Google Sign In. Try again.',
  //         );
  //       }
  //     }
  //   }

  //   return user;
  // }

  //******************************************************************************* */

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    try {
      loadingDialogBox(context, 'Validating details');
      GoogleSignInAccount? googleUser = await GoogleSignIn(
              clientId:
                  "470516067456-q3gi4t1tqo55gfd1cp48uhlbbli082k6.apps.googleusercontent.com")
          // above clientId deni hoti hai, for flutter web me google sign in
          // YE CLIENT ID GOOGELE CONSOLE ME JANA THEN LEFT SIDE ME CREDENTIALS NAAM KA OPTION RHEGA, CREDENTIAL ME JANA
          .signIn();

      if (googleUser == null) {
        return null; // Return null if the user cancels the sign-in process.
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint('${userCredential.user!.displayName}       😎😎😎😎😎😎😎😎');
      debugPrint('${userCredential.user!.email}       😎😎😎😎😎😎😎😎');
      debugPrint('${userCredential.user!.emailVerified}   😎😎😎😎😎😎😎😎');

      if (userCredential.user != null) {
        bool isUidExists = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((docSnapshot) => docSnapshot.exists);
        if (isUidExists) {
          // the account is already in firestore but with email login, then just do update displayName rest data firestore me vaise hi rehne do
          await users.doc(userCredential.user!.uid).update({
            'name': userCredential.user!.displayName,
          }).then((_) {
            debugPrint('Account added into firestore done 😎😎😎😎😎😎😎😎');
            customSnackBar(
                context: context, content: 'Google SignUp Successful');
          }).catchError((onError) {
            debugPrint('error ->$onError       😎😎😎😎😎😎😎😎');
            customSnackBar(
              context: context,
              content: 'Failed to add user to firestore database, $onError',
            );
          });
        } else {
          //making new fresh google account here, aisha google account jiska email registered na hua ho through email signUp
          await users.doc(userCredential.user!.uid).set({
            'uid': userCredential.user!.uid,
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'password': 'its_google_signIn So No pswd',
          }).then((_) {
            debugPrint(
                'Account added into firestore done       😎😎😎😎😎😎😎😎');
            customSnackBar(
                context: context, content: 'Google SignUp Successful');
          }).catchError((onError) {
            debugPrint('error ->$onError       😎😎😎😎😎😎😎😎');
            customSnackBar(
              context: context,
              content: 'Failed to add user to firestore database, $onError',
            );
          });
        }
      }
      return userCredential.user;
    } catch (error) {
      debugPrint('Error -> $error       😎😎😎😎😎😎😎😎');
      customSnackBar(
        context: context,
        content: 'Failed to sign in with Google, $error',
      );
      return null;
    }
  }

//************************************* Email Sign In  ************************** */
//************************************* Email Sign In  ************************** */

  Future<bool> getAdminCredentialEmailAndPassword(
      {required BuildContext context,
      required String email,
      String? firstName,
      // first name and last name are 'string?' because this getAdminCredentialEmailAndPassword func is called in both lognpage as well as signUppage, and loginPage par to first name,last name null aayega ,sirf sdignuppage me first name,last name ki kuchh value aayegi
      String? lastName,
      required String password,
      required bool isLoginUser}) async {
    //
    bool isThisEmailExists = await isEmailExists(email);

//
    try {
      if (isLoginUser) {
        // if (its havingg the login page,)
        debugPrint('Starting SignInWithEmail Func       😎😎😎😎😎😎😎😎');
        await signInWithEmail(context, email, password);
      } else {
        //NOTE else is here for signUp page wala case
        if (isThisEmailExists == false) {
          await registerWithEmail(
              context, email, password, firstName!, lastName!);
        } else {
          customSnackBar(
              context: context,
              content: 'An account already exists with this email');
        }
      }
    } catch (e) {
      customSnackBar(context: context, content: e.toString());
    }
    return isThisEmailExists;
  }
//************************************************************************************** */

  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      loadingDialogBox(context, 'Validating details');
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.toLowerCase(), password: password);
      //NOTE It is inbuilt func of firebaseAuth, bas firebase auth ko enable kr do and then firebase auth me email/password provider ko enable kr do (simply tick there)
      debugPrint('SignIn Completed       😎😎😎😎😎😎😎😎');
      //NOTE basically the await key word is ensuring that signIn is completed or not, if signIn complete hoga, to hi await ke neeche aayega code, and tohi LocationScreen pe push hoga,so await key word is ensuring that signIn is done or not.
      //NOTE now login ho chuka hai so jabtak code me FirebaseAuth.instance.logOut run nai hota tabtak FirebaseAuth.instance.currentUser would return this current account
      debugPrint(
          '$credential is the credential for this email😎😎😎'); // if signIn is completed then pop loadingDialogBox and open LocationScreen
      debugPrint(
          '${FirebaseAuth.instance.currentUser!.emailVerified.toString() == 'true'}   <-- veriied or not   😎😎😎😎😎😎😎😎');

      if (credential.user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            MainNavigationScreen.screenId, (route) => false);
      } else {
        customSnackBar(
            context: context, content: 'Please check with your credentials');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); //pop loadingDialogBox
      if (e.code == 'user-not-found') {
        customSnackBar(
            context: context, content: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        customSnackBar(
            context: context, content: 'Wrong password entered for that user.');
      } else {
        customSnackBar(context: context, content: 'error: ${e.toString()}');
      }
    } catch (e) {
      //firebaseAuth ke alawa koi exception aaya to wo yaha catch hoga
      Navigator.pop(context); // Close the loading dialog box
      debugPrint('${e.toString()}       😎😎😎😎😎😎😎😎');
      customSnackBar(context: context, content: 'error:${e.toString()}');
    }
  }

//************************************************************************************** */
//************************************************************************************** */
//************************************************************************************** */
//************************************************************************************** */
  // LOCATION SCREEN ME NAVIGATE KR DO YE LINE BHI ADD KRO IS SIGNUP ME
  // AND IT IS ADDING NON VERIFIED EMAIL ID(FAKE EMAIL IDs) TO FIRESTORE, YE BHI THIK KRO, AS U HAVE WRITTEN ADDINTO FIRESTORE IN BOTH CASES
  Future<void> registerWithEmail(BuildContext context, String email,
      String password, String firstName, String lastName) async {
    try {
      loadingDialogBox(context, 'Validating details');

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      ); //NOTE createUserWithEmailAndPassword is inbuilt func of firebaseAuth, bas firebase auth ko enable kr do and then firebase auth me email/password provider ko enable kr do (simply tick there), then bas is func ko call krne se firebaseAuth me ye email register ho jata h
      debugPrint('Account added into firebaseAuth      😎😎😎😎😎😎😎😎');

      await credential.user!.sendEmailVerification();
      debugPrint('email verification msg sent       😎😎😎😎😎😎😎😎');

      Navigator.pushReplacementNamed(context, EmailVerifyScreen.screenId);
      debugPrint('Verify Screen  opened    😎😎😎😎😎😎😎😎');
      //

//
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        //
        if (user != null) {
          debugPrint('Timer 80s starts here 😎😎😎😎😎😎😎😎');
          // await Future.delayed(const Duration(seconds: 45));
          debugPrint('Timer 80s completed here 😎😎😎😎😎😎😎😎');
          debugPrint(
              '${user.emailVerified}    <-user.emailVerified   😎😎😎😎😎😎😎😎');
          await user.reload(); // Refresh user's data se bhi not worked
          debugPrint(
              '${user.emailVerified}    <-user.emailVerified   😎😎😎😎😎😎😎😎');

          if (user.emailVerified) {
            debugPrint('Email is verified       😎😎😎😎😎😎😎😎');
            await users.doc(user.uid).set({
              'uid': user.uid,
              'name': "$firstName $lastName",
              'email': email,
              'password': password,
            }).then((_) {
              debugPrint(
                  'Account added into firestore done       😎😎😎😎😎😎😎😎');
              customSnackBar(
                  context: context,
                  content: 'SignUp Successful\n Go Back To sign In Now');
            }).catchError((onError) {
              debugPrint('error ->$onError       😎😎😎😎😎😎😎😎');
              customSnackBar(
                context: context,
                content: 'Failed to add user to database, please try again',
              );
            });
          } else {
            // customSnackBar(
            //   context: context,
            //   content: 'Please verify your email before proceeding.',
            // );
            // NOTE email verify nai ho rha, resolve this issue,abhi ke liye verified/unverified dono trh ke accounts firestore me add kr de rha hu
            // i.e.. IS line se users.doc() wala adding into firestore ka code hata dena, after fixing the issue
            debugPrint(
                'User Email is NOT verified, still I am adding this account into firestore       😎😎😎😎😎😎😎😎');
            debugPrint(
                'BECAUSE VERIFICATION MSG GIR RHA,verify bhi ho ja rha, but user.emailverified is still returning false ,(ask this issue to seniors to resolve it       😎😎😎😎😎😎😎😎');
            // NOTE here maine firebaseAuth.credential ko print kra ke dekha, us credential me isEmailVerified=true aa rha tha
            // SO no doubt email verify to ho ja rha h but firbhi user.emailVerified false return kr rha
            // SO I thind ye user.emailVerified func hi galat h, isko true return krna chahiye but false return kr rha
            await users.doc(user.uid).set({
              'uid': user.uid,
              'name': "$firstName $lastName",
              'email': email.toLowerCase(),
              'password': password, //password ko firestore me nai rkhte h
              // maine rkha h because i wanna know it
            }).then((_) {
              customSnackBar(
                  context: context,
                  content:
                      'SignUp Successful\nDo verify And Then Go Back To sign In Now');
            }).catchError((onError) {
              debugPrint('error ->$onError       😎😎😎😎😎😎😎😎');
              customSnackBar(
                context: context,
                content: 'Failed to add user to database, please try again',
              );
            });
          }
        } else {
          debugPrint('user==null hai       😎😎😎😎😎😎😎😎');
        }
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        customSnackBar(
            context: context, content: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        customSnackBar(
          context: context,
          content:
              'This account already exists for this email.\nGo to MailBox to verify email if not done and then do login.\nIf already verified then continue to login In.',
        );
      }
    } catch (e) {
      debugPrint('error ->$e       😎😎😎😎😎😎😎😎');
      customSnackBar(
          context: context, content: 'Error occurred: ${e.toString()}');
    }
  }
  //**************************************************************************** */
}
