import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../components/signup_buttons.dart';
import '../constants/colors.dart';
import '../constants/validators.dart';
import '../constants/widgets.dart';
import '../services/auth.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isPasswordObsecured = true;
  Auth myAuthService = Auth();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _firstNameNode;
  late final FocusNode _lastNameNode;
  late final FocusNode _emailNode;
  late final FocusNode _passwordNode;
  late final FocusNode _confirmPasswordNode;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameNode = FocusNode();
    _lastNameNode = FocusNode();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    _confirmPasswordNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: _firstNameNode,
                            //NOTE
                            //validator is just that returns a textmsg that 'please enter yr first name' on tapping signUp button, i.e..if validator is not returning null then signUp button wont work
                            //signUp button would work only if validator is satisfied, i.e.. validator gets activated only when signUp button is tapped, & it decides that signUp button should be allowed to run or not, if validator is returning null then it runs
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'first name');
                            },
                            controller: _firstNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                                hintText: 'Enter your First Name',
                                hintStyle: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _lastNameNode,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'last name');
                            },
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                                hintText: 'Enter your Last Name',
                                hintStyle: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _emailNode,
                      controller: _emailController,
                      validator: (value) {
                        return validateEmail(value,
                            EmailValidator.validate(_emailController.text));
                      }, //NOTE :
                      // In the validator property of the TextFormField, the value parameter and _emailController.text are essentially the same thing
                      // here value is checking for email should not be empty and EmailValidator.validate() is an inbuilt func that checks for syntax of email
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          hintText: 'Enter your Email',
                          hintStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _passwordNode,
                      obscureText: isPasswordObsecured,
                      controller: _passwordController,
                      validator: (value) {
                        // return validatePassword(
                        //     value,
                        //     _passwordController
                        //         .text); // YE IMPROPER LAG RHA THA, TO new validatepassword func bnaya
                        return validatePassword(value);
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordObsecured
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.visibility_off,
                                color: isPasswordObsecured
                                    ? greyColor
                                    : blackColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordObsecured = !isPasswordObsecured;
                                });
                              }),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          hintText: 'Enter Your Password',
                          hintStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _confirmPasswordNode,
                      obscureText: true, //means text hidden=true
                      controller: _confirmPasswordController,
                      validator: (value) {
                        return validateSamePassword(
                            value, _passwordController.text);
                      },
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          hintText: 'Enter Your Confirm Password',
                          hintStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    myRoundedButton(
                        context: context,
                        bgColor: secondaryColor,
                        text: 'Sign Up',
                        textColor: whiteColor,
                        onPressed: () async {
                          debugPrint(
                              'Sign Up Button Tapped       😎😎😎😎😎😎😎😎');
                          if (_formKey.currentState!.validate()) {
                            debugPrint(
                                'Validating form done,going to do auth       😎😎😎😎😎😎😎😎');
                            await myAuthService
                                .getAdminCredentialEmailAndPassword(
                                    context: context,
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    isLoginUser: false);
                            debugPrint('Auth completed       😎😎😎😎😎😎😎😎');

                            //NOTE: actually getAdminCredentialEmailAndPassword func is called in both pages login page and signUp page, so loginPage me isLoginUser:true pass kiya h and signUp page me isLoginUser: false pass kiya h
                          }
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text(
                'By Signing up you agree to our Terms and Conditions, and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: greyColor,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Or',
              style: TextStyle(
                fontSize: 18,
                color: greyColor,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SignUpButtons(),
          ],
        ),
      ),
    );
  }
}
