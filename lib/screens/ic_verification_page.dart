import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/screens/loginpage.dart';
import 'package:saint_schoolparent_pro/screens/registrationpage.dart';
import 'package:saint_schoolparent_pro/theme.dart';
import 'package:get/get.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: getHeight(context) *0.16, bottom: getHeight(context) * 0.05),
                child: Image.asset(
                  'assets/logo.png',
                  height: getHeight(context) * 0.20,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.05),
                child: CustomTextformField(
                  prefixIcon: Icon(Icons.person_pin_sharp),
                  controller: TextEditingController(),
                  hintText: 'Parent IC NO',
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: getHeight(context) * 0.10),
                child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(16
                      ),
                        shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                    )),
                    onPressed: () {
                      Get.to(() => RegistrationPage());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(context) * 0.15, vertical: getHeight(context) * 0.02),
                      child: Text('Verify'),
                    )),
              ),
            ],
          ),
        ));
  }
}

class CustomTextformField extends StatelessWidget {
  const CustomTextformField({
    Key? key,
    this.controller,
    this.obscureText,
    required this.hintText,
    this.prefixIcon, this.suffixIcon,
  }) : super(key: key);

  final TextEditingController ?controller;
  final bool? obscureText;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextFormField(
           validator: (value) {
      if (value == null || value.isEmpty) {
      return 'Do not let the filed empty';
      }
      return null;
      },
          controller:controller,
          onChanged: (String) {},
          autofocus: true,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(

              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: lightColorScheme.secondary,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: lightColorScheme.secondary,
                  width: 2,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              prefixIcon: prefixIcon,

          suffixIcon: suffixIcon
          ),
        ),
      ),
    );
  }
}
