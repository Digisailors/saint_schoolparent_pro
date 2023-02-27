import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';

import '../theme.dart';
import 'ic_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisible = true;
  var emailController = TextEditingController();
  final _fomKey = GlobalKey<FormState>();
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: getHeight(context) * 0.25,
            child: Form(
              key: _fomKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(' Please enter your registered e-mail'),
                  ),
                  CustomTextformField(
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Email',
                    controller: emailController,
                    validator: (p0) {
                      if (emailController.text.removeAllWhitespace.isEmail) {
                        return null;
                      }
                      return 'Please enter a valid email';
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset password'),
              onPressed: () {
                if (_fomKey.currentState!.validate()) {
                  auth.resetPassword(email: emailController.text.removeAllWhitespace).then((value) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email has been sent.")));
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error occured")));
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: getHeight(context) * 0.10, bottom: getHeight(context) * 0.05),
              child: Image.asset(
                'assets/logo.png',
                height: getHeight(context) * 0.20,
              ),
            ),
            Text(
              'Welcome',
              style: getText(context).headline5,
            ),
            Text(
              'Login To Your Account',
              style: getText(context).bodyText1!.apply(color: getColor(context).secondary),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.05),
              child: CustomTextformField(
                prefixIcon: const Icon(Icons.email),
                hintText: 'Email',
                controller: email,
                validator: (p0) {
                  if (email.text.removeAllWhitespace.isEmail) {
                    return null;
                  }
                  return 'Please enter a valid email';
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.001),
              child: CustomTextformField(
                prefixIcon: const Icon(Icons.password),
                controller: password,
                hintText: 'Password',
                obscureText: isVisible,
                validator: (p0) {
                  if (password.text.isEmpty) {
                    return 'Please enter a password';
                  }
                },
                suffixIcon: IconButton(
                  icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Logging in got first time?',
                    style: getText(context).button,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const VerificationPage());
                      },
                      child: Text(
                        'Click here',
                        style: getText(context).button?.apply(color: getColor(context).inversePrimary),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text(
                    'Forgot Password?',
                    style: getText(context).button?.apply(color: getColor(context).inversePrimary),
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: getHeight(context) * 0.10),
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                  )),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Login Successfully')),
                      // );
                      // Get.to(() => const BottomRouter());
                      auth.signInWithEmailAndPassword(email.text.removeAllWhitespace, password.text).onError((error, stackTrace) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              if (error is FirebaseAuthException) {
                                return AlertDialog(
                                  title: Text(error.code),
                                  content: Text(error.message ?? 'Unknown error occured, Please try again'),
                                  actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Okay"))],
                                );
                              } else {
                                return AlertDialog(
                                  title: const Text("Unknown Error"),
                                  content: const Text('Unknown error occured, Please try again'),
                                  actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Okay"))],
                                );
                              }
                            });
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.15, vertical: getHeight(context) * 0.02),
                    child: const Text('Login'),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
