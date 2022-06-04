import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../theme.dart';
import 'ic_verification_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              Padding(
                padding:  EdgeInsets.only(top: getHeight(context)*0.10,bottom:getHeight(context)*0.10),
                child: Image.asset('assets/logo.png',height: getHeight(context)*0.20,),
              ),



              Padding(
                padding:  EdgeInsets.symmetric(horizontal: getWidth(context)*0.02,vertical: getHeight(context)*0.05),
                child: CustomTextformField(
                  prefixIcon:Icon(Icons.person_pin_sharp),
                  controller: TextEditingController(),
                  hintText: 'Parent IC NO',

                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: getWidth(context)*0.02,vertical: getHeight(context)*0.01),
                child: CustomTextformField(
                  prefixIcon:Icon(Icons.person_pin_sharp),
                  controller: TextEditingController(),
                  hintText: 'Parent IC NO',

                ),
              ),



              Padding(

                padding:  EdgeInsets.symmetric(vertical: getHeight(context)*0.10),
                child: ElevatedButton(


                    style: ButtonStyle(
                        shape:MaterialStateProperty.all( RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(100.0)
                        ),)
                    ),
                    onPressed: (){

                      Get.to(()=>LoginPage());

                    }, child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: getWidth(context)*0.15,vertical: getHeight(context)*0.02),
                  child: Text('Verify'),
                )),
              )


            ],
          ),
        )
    );
  }
}