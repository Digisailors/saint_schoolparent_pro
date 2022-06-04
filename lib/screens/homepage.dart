import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/theme.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: ListView.builder(

          itemCount: 20,
          itemBuilder: (context,index){
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Color(0xFFF5F5F5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: SizedBox(height: getHeight(context)*0.30,width: getWidth(context)*0.95,

            child: Row(

              children: [

                Expanded(
                    flex: 2,
                    child:Container(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: getWidth(context)*0.15,
                              backgroundImage: AssetImage('assets/logo.png'),
                            ),
                          ),

                          ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                                backgroundColor: MaterialStateProperty.all(Color(0XFF48B253))
                              ),
                              onPressed: (){}, child: Text('Pickup')
                          )

                        ],
                      ),

                ) ),
                Expanded(
                    flex: 5,
                    child:Container(
                      child:Column(

                        children: [
                          ListTile(
                            enabled: true,
                            title: Text('Andrew Simons',style: Theme.of(context).textTheme.bodyText1,),
                            trailing: SizedBox(
                              height: getHeight(context)*0.03,
                              width: getWidth(context)*0.18,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiaryContainer),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),

                                ),
                                onPressed: () {  },
                                child: Text('59:00',style: getText(context).labelSmall,),

                              ),
                            ),

                          ),

                      Table(
                        columnWidths: <int,TableColumnWidth>{

                          0:FixedColumnWidth(30),
                          1:FixedColumnWidth(30),
                          2:FixedColumnWidth(30)

                        },
                        children: [




                        ],





                      )




                        ],
                      ),


                    ) ),

              ],
            ),


            ),
          ),
        );
      }),

    );
  }
}
