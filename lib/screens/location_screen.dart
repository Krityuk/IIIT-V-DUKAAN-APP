import 'package:flutter/material.dart';
import 'package:icd_kaa_olx/screens/main_navigation_screen.dart';
import 'package:icd_kaa_olx/services/auth.dart';
import 'package:lottie/lottie.dart';

import '../components/large_heading_widget.dart';
import '../constants/colors.dart';
import '../constants/widgets.dart';
import '../services/user.dart';

UserService currentFirebaseUser = UserService();

class LocationScreen extends StatefulWidget {
  final bool? popToUserForm;
  static const String screenId = 'location_screen';
  const LocationScreen({
    Key? key,
    this.popToUserForm,
  }) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  Auth myAuthService = Auth();

  @override
  void dispose() {
    _phoneNoController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LargeHeadingWidget(
              heading: 'Enter Location',
              subheadingTextSize: 16,
              headingTextSize: 30,
              subHeading:
                  'To continue, we need to know your sell/buy location so that we can further assist you',
              sizeWidget: 0.25,
              topPadding: 0.1,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: screenHeight(context) * 0.3,
              width: screenWidth(context) * 0.8,
              child: Lottie.asset(
                'assets/lottie/location_lottie.json',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _phoneNoController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.length != 10) {
                          return 'Please enter a valid phone no';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your address(room no)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address(room no)';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    myRoundedButton(
                        context: context,
                        bgColor: secondaryColor,
                        text: 'Confirm',
                        textColor: whiteColor,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            debugPrint('Validating location form done 😎😎😎');
                            debugPrint('Going to Update 😎😎😎');
                            await currentFirebaseUser
                                .updateFirebaseAccount(context, {
                              'address': _addressController.text,
                              'mobile': _phoneNoController.text,
                              // 'city': 'Ranchi',
                              //NOTE YE UPDATE FUNC H, isme kitne bhi attributes daal do to upadate sab update hojata h,
                              //i.e.. agar 'city' naam ki field snapshot me nai hai, and yaha se city field update kroge to city field create ho jaegi in that document
                              // 'country': 'India'
                            }).then((value) {
                              debugPrint('Added phoneNo,roomNo Done 😎😎😎😎');
                              if (widget.popToUserForm == true) {
                                Navigator.of(context).pop();
                              } // NOTE pushNamedAndRemoveUntil is used to remove all previous screen and get navigated to mainNavigationScreen
                              else {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  MainNavigationScreen.screenId,
                                  (route) => false,
                                );
                              }
                            });
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
