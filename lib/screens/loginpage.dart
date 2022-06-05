import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/screens/homepage.dart';

import '../theme.dart';
import 'ic_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool Isvisible = true;

  final _formKey = GlobalKey<FormState>();
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
              padding: EdgeInsets.only(
                  top: getHeight(context) * 0.10,
                  bottom: getHeight(context) * 0.10),
              child: Image.asset(
                'assets/logo.png',
                height: getHeight(context) * 0.20,
              ),
            ),

            Text('Welcome',style: getText(context).headline5,),
            Text('Login To Your Accout',style: getText(context).bodyText1!.apply(color:getColor(context).secondary),),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getWidth(context) * 0.02,
                  vertical: getHeight(context) * 0.05),
              child: CustomTextformField(
                prefixIcon: Icon(Icons.email),
                controller: TextEditingController(),
                hintText: 'Email',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getWidth(context) * 0.02,
                  vertical: getHeight(context) * 0.01),
              child: CustomTextformField(
                prefixIcon: Icon(Icons.password),
                controller: TextEditingController(),
                hintText: 'Password',
                obscureText: Isvisible,
                suffixIcon: IconButton(
                  icon: Isvisible? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off)
                      ,
                  onPressed: () {
                    setState((){
                      Isvisible=!Isvisible;

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
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0)),
                  )),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login Successfully')),
                      );
                      Get.to(()=>HomePage());
                    }
                  },



                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(context) * 0.15,
                        vertical: getHeight(context) * 0.02),
                    child: Text('Verify'),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
