import 'package:flutter/material.dart';

import 'appointmentlist.dart';


class AlertPage extends StatefulWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Notifications'),
      ),


      body:ListView.builder(
          itemCount: 20,
          itemBuilder: (context,index){


        return  Card(

          child: ListTile(
            leading: CircleAvatar(

              backgroundImage: AssetImage('assets/logo.png'),
            ),

            title: Text('Breakfast'),

            subtitle: Text('Taken'),
            trailing:Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text('Aug 15 2022'),
                Text('9:30 AM'),

              ],
            )

          ),
        );

      })

    );
  }
}
