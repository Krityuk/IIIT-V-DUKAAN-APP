import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../components/login_buttons.dart';
import '../constants/colors.dart';
import '../constants/validators.dart';
import '../constants/widgets.dart';
import '../screens/auth/registerscreen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../services/auth.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  Auth myAuthService = Auth();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailNode;
  late final FocusNode _passwordNode;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordObsecured = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: _formKey, //Form widget is used just to use _formKey
            child: Column(
              children: [
                TextFormField(
                  focusNode: _emailNode,
                  // focus node is made so that we can use properties like onEditingComplete func as shown below
                  controller: _emailController,
                  //  if validator(value) == null, means valid email
                  validator: (value) {
                    return validateEmail(
                        value, EmailValidator.validate(_emailController.text));
                  }, //passing value,_pswdController.text in below textField
                  // keyboardType: TextInputType.text,
                  keyboardType: TextInputType.emailAddress,
                  // it decides what type of keyboard comes
                  // keyboardType: TextInputType.number,
                  // keyboardType: TextInputType.datetime,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_passwordNode);
                  }, // When the user completes input in the "_emailNode" field, the focus is programmatically moved to the "_pswdNode" field using requestFocus().
                  //i.e.. keyboard ke tick button ko click krne pe password controller wali field me chala jaega
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your Email',
                      hintStyle: TextStyle(
                        color: greyColor,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  focusNode: _passwordNode,
                  controller: _passwordController,
                  validator: (value) {
                    // return validatePassword(
                    //     value,
                    //     _passwordController
                    //         .text); // YE IMPROPER LAG RHA THA to new validatePassword func bnaya
                    return validatePassword(value);
                  },
                  obscureText: isPasswordObsecured,
                  // obscureText: true,// Should text be obscured?
                  // obscureText: false,
                  //initially this var is declared as true (see above)

                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordObsecured
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off,
                            color: isPasswordObsecured ? greyColor : blackColor,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordObsecured = !isPasswordObsecured;
                            });
                          }),
                      labelText: 'Password',
                      hintText: 'Enter Your Password',
                      hintStyle: TextStyle(
                        color: greyColor,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                //
                Container(
                  // decoration: BoxDecoration(color: myTestingColor),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 5,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ResetPasswordScreen.screenId);
                    },
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                myRoundedButton(
                    context: context,
                    bgColor: secondaryColor,
                    text: 'Sign In',
                    textColor: whiteColor,
                    onPressed: () async {
                      // NOTE ye '_formKey.currntState!.validate' is calling the validate func of email and pswd
                      // yaha par call ho ho rha upar declare kiya hua validators

                      if (_formKey.currentState!.validate()) {
                          await myAuthService.getAdminCredentialEmailAndPassword(
                              context: context,
                              email: _emailController.text,
                              password: _passwordController.text,
                              isLoginUser: true);
                      }
                    }),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            text: 'Don\'t have an account? ',
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacementNamed(
                        context, RegisterScreen.screenId);
                  },
                text: 'Create new account',
                style: TextStyle(
                  color: secondaryColor,
                ),
              )
            ],
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 14,
              color: greyColor,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
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
        const LoginInButtons(), //Sign In with phone and google are in this line
      ],
    );
  }
}
