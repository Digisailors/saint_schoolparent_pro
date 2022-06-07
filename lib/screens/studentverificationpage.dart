import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/screens/bottomrouter.dart';
import 'package:saint_schoolparent_pro/screens/homepage.dart';

import '../theme.dart';
import 'ic_verification_page.dart';

class Studentverification extends StatefulWidget {
  const Studentverification({Key? key}) : super(key: key);

  @override
  State<Studentverification> createState() => _StudentverificationState();
}

class _StudentverificationState extends State<Studentverification> {
  bool Isvisible = true;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Verification'),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Verify your child\'s IC NO',style: getText(context).headline6,),
                ),


                Padding(
                  padding: EdgeInsets.only(
                    top:getHeight(context) * 0.05,bottom: getWidth(context) * 0.02,

                    left:  getWidth(context) * 0.02, right:  getWidth(context) * 0.02,
                  ) ,


                  child: CustomTextformField(
                    prefixIcon: Icon(Icons.person),
                    controller: TextEditingController(),
                    hintText: 'Parent IC NO',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.02,
                      vertical: getHeight(context) * 0.02),
                  child: CustomTextformField(
                    prefixIcon: Icon(Icons.perm_contact_cal),
                    controller: TextEditingController(),
                    hintText: 'Student IC NO',
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
                            const SnackBar(content: Text('Registred Successfully')),
                          );
                          Get.to(()=>BottomRouter());
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
