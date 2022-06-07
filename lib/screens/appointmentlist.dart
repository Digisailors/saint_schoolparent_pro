import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/screens/appointmetpage.dart';
import 'package:saint_schoolparent_pro/theme.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 2,
      child: Scaffold(

        appBar: AppBar(
          title: const Text('Appointments'),
          centerTitle: true,

          bottom: const PreferredSize(preferredSize:Size.fromHeight(40) , child: TabBar(
            tabs: [
            Tab(
              child: Text('Upcoming'),
            ),
            Tab(
              child: Text('Completed'),
            ),


          ],),),


        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(()=>AppointmentPage());
          },
          child: Icon(Icons.add),
        ),

        body: TabBarView(


          children: [

               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ListView.builder(

                     itemCount: 20,
                     itemBuilder: (context,index){


                   return  AppointmentTile();

                 }),
               ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(

                  itemCount: 20,
                  itemBuilder: (context,index){


                    return  AppointmentTile();

                  }),
            ),



          ],


        ),


      ),
    );
  }
}

class AppointmentTile extends StatelessWidget {
  const AppointmentTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child:Column(

          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'
                    ''),
              ),
              title: Text('Teacher Name'),
              trailing: SizedBox(
                width: getWidth(context)*0.3,
                child: Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.greenAccent,
                      ),
                    ),
                    Text('Approved',style: getText(context).bodySmall,),
                  ],
                ),
              ),
              subtitle: Text('Science'),
              
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),


                color: Colors.white60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [



                      Image.network('https://cdn-icons-png.flaticon.com/512/2784/2784459.png',height: 32,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('9:30 AM-10:30 AM'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.network('https://cdn-icons-png.flaticon.com/512/3652/3652191.png',height: 32,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 20),
                        child: Text('Aug 15 2022'),
                      )



                    ],
                  ),
                ),

              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                ElevatedButton(
                    style: ButtonStyle(
                        // backgroundColor:MaterialStateProperty.all(getColor(context).errorContainer),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ))
                    ),
                    onPressed: (){}, child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: getWidth(context)*0.08),
                      child: Text('Cancel',style: getText(context).bodySmall?.apply(color: Colors.white)),
                    )),

                ElevatedButton(
                    style: ButtonStyle(
                      // backgroundColor:MaterialStateProperty.all(getColor(context).errorContainer),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ))
                    ),
                    onPressed: (){}, child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: getWidth(context)*0.06 ),
                  child: Text('reschedule',style: getText(context).bodySmall?.apply(color: Colors.white)),
                )),
              ],
            ),
            
          ],

        ),

      )
    );
  }
}
