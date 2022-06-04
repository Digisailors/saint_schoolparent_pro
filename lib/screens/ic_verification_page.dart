import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/screens/loginpage.dart';
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
        body: DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: getHeight(context) * 0.10, bottom: getHeight(context) * 0.10),
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
              padding: EdgeInsets.symmetric(
                  horizontal: getWidth(context) * 0.02, vertical: getHeight(context) * 0.01),
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
                      shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                  )),
                  onPressed: () {
                    Get.to(() => LoginPage());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(context) * 0.15, vertical: getHeight(context) * 0.02),
                    child: Text('Verify'),
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}

class CustomTextformField extends StatelessWidget {
  const CustomTextformField({
    Key? key,
    required this.controller,
    this.obscureText,
    required this.hintText,
    this.prefixIcon,
  }) : super(key: key);

  final TextEditingController controller;
  final bool? obscureText;
  final String hintText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextFormField(
          controller: TextEditingController(),
          onChanged: (String) {},
          autofocus: true,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
              hintText: 'Parent IC NO',
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
              prefixIcon: prefixIcon),
        ),
      ),
    );
  }
}
