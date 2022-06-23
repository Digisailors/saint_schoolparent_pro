import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/landing_page.dart';
import 'package:saint_schoolparent_pro/models/biodata.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/widgets/dropdown.dart';

import '../theme.dart';
import 'ic_verification_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isVisible = true;
  final email = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final name = TextEditingController();
  final icNumber = TextEditingController();
  Gender gender = Gender.unspecified;
  final address = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Registration'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: getHeight(context) * 0.01,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    height: getHeight(context) * 0.20,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getHeight(context) * 0.05,
                    bottom: getWidth(context) * 0.02,
                    left: getWidth(context) * 0.02,
                    right: getWidth(context) * 0.02,
                  ),
                  child: CustomTextformField(
                    controller: name,
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Name',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getWidth(context) * 0.02,
                    bottom: getWidth(context) * 0.02,
                    left: getWidth(context) * 0.02,
                    right: getWidth(context) * 0.02,
                  ),
                  child: CustomTextformField(
                    controller: icNumber,
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'IC NUmber',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(context) * 0.02,
                    vertical: getHeight(context) * 0.02,
                  ),
                  child: CustomTextformField(
                    controller: address,
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Address',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.02),
                  child: CustomDropdownField<Gender>(
                    items: const [
                      DropdownMenuItem(value: Gender.male, child: Text("MALE")),
                      DropdownMenuItem(value: Gender.female, child: Text("FEMALE")),
                      DropdownMenuItem(value: Gender.unspecified, child: Text("UNSPECIFIED")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        gender = val ?? gender;
                      });
                    },
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Gender',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.02),
                  child: CustomTextformField(
                    controller: email,
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Email',
                    validator: (string) {
                      if (email.text.isEmpty) {
                        return "Do not leave this field empty";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.02),
                  child: CustomTextformField(
                    controller: passwordController,
                    prefixIcon: const Icon(Icons.password),
                    hintText: 'Password',
                    obscureText: isVisible,
                    validator: (val) {
                      if (passwordController.text != confirmPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
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
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.01),
                  child: CustomTextformField(
                    prefixIcon: const Icon(Icons.password),
                    hintText: 'Confirm Password',
                    obscureText: isVisible,
                    controller: confirmPasswordController,
                    validator: (val) {
                      if (passwordController.text != confirmPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
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

                          var parent = Parent(icNumber: icNumber.text, email: email.text, name: name.text, children: [], gender: gender);
                          // print(parent.toJson());
                          auth.createUserWithEmailAndPassword(email.text, passwordController.text).then((value) {
                            if (value?.uid != null) {
                              parent.uid = value!.uid;
                              ParentController.registerParent(parent)
                                  .then((value) => Get.offAll(() => const LandingPage()))
                                  .onError((error, stackTrace) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Error occured"),
                                        content: Text(error.toString()),
                                      );
                                    });
                                return null;
                              });
                            }
                          });

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Registred Successfully')),
                          // );
                          // Get.to(() => const BottomRouter());
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.15, vertical: getHeight(context) * 0.02),
                        child: const Text('Submit'),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
