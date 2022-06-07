import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/screens/studentverificationpage.dart';
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
      appBar: AppBar(

        title: Text('Home'),
        centerTitle: true,
        leading: Icon(Icons.logout),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(onPressed: (){

              Get.to(()=>Studentverification());
            },icon: Icon(Icons.person_add),),
          )
        ],
      ),

      body: ListView.builder(

          itemCount: 20,
          itemBuilder: (context,index){
        return StudentTile();
      }),

    );
  }
}

class StudentTile extends StatelessWidget {
  const StudentTile({
    Key? key,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color(0xFFF5F5F5),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: SizedBox(height: getHeight(context)*0.285,width: getWidth(context)*0.95,

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

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
                  Divider(),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Table(

                      columnWidths: <int,TableColumnWidth>{

                        0:FixedColumnWidth(getWidth(context)*0.05),
                        1:FixedColumnWidth(getWidth(context)*0.40),
                        2:FixedColumnWidth(getWidth(context)*0.20)

                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(

                          ),
                          children: [


                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Container(
                                width: 10,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(30

                                  ),
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text('Attendance'),
                            ),
                            Text('79'+'%')



                          ]
                        ),
                        TableRow(
                            decoration: BoxDecoration(

                            ),
                            children: [


                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  width: 10,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(30

                                    ),
                                  ),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text('In Time'),
                              ),
                              Text('9:30 Am')



                            ]
                        ),
                        TableRow(
                            decoration: BoxDecoration(

                            ),
                            children: [


                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  width: 10,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(30

                                    ),
                                  ),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text('Out Time'),
                              ),
                              Text('5:30 PM')



                            ]
                        ),
                        TableRow(
                            decoration: BoxDecoration(

                            ),
                            children: [


                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  width: 10,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(30

                                    ),
                                  ),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text('Breakfast'),
                              ),
                              Text('Taken')



                            ]
                        ),
                        TableRow(
                            decoration: BoxDecoration(

                            ),
                            children: [


                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  width: 10,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(30

                                    ),
                                  ),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text('Lunch'),
                              ),
                              Text('Not Taken')



                            ]
                        ),






                      ],





                    ),
                  )




                    ],
                  ),


                ) ),

          ],
        ),


        ),
      ),
    );
  }
}
