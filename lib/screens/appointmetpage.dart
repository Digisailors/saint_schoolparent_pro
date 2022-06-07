import 'package:flutter/material.dart';
import 'package:saint_schoolparent_pro/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_range/time_range.dart';



class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {


  int? _value = 1;
  DateTime _SeletedDate= DateTime.now();




  final _defaultTimeRange = TimeRangeResult(
    TimeOfDay(hour: 14, minute: 50),
    TimeOfDay(hour: 15, minute: 20),
  );
  TimeRangeResult? _timeRange=TimeRangeResult(
    TimeOfDay(hour: 14, minute: 50),
    TimeOfDay(hour: 15, minute: 20),
  );
  @override
  void initState() {
    super.initState();
    _timeRange = _defaultTimeRange;
    _SeletedDate= DateTime.now();


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text('Make Appointment',


      ),centerTitle: true,




      ),
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,


          children: [

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Responsible person',style: getText(context).titleLarge,),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: ListTile(
                  title: const Text('Teacher name'),
                  subtitle: const Text('Subject'),


                  trailing: CircleAvatar(
                    child: Image.network('https://cdn-icons-png.flaticon.com/512/949/949666.png'),
                  ),
                ),
              ),
            ),
          Divider(),

          ListTile(

            title: Text('Date',style: getText(context).titleLarge,),


          ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(

                elevation: 2,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfDateRangePicker(
                    selectionMode: DateRangePickerSelectionMode.single,
                   onSelectionChanged: (DateRangePickerSelectionChangedArgs date ){

                      print(date.value);
                      setState((){
                        _SeletedDate= date.value;

                      });

                   },





                  ),
                ),
              ),
            ),
            Divider(),



            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[





                ListTile(

                  title: Text('Time',style: getText(context).titleLarge,),


                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TimeRange(
                    fromTitle: Text(
                      'FROM',
                      style: getText(context).button
                    ),
                    toTitle: Text(
                      'TO',
                      style: getText(context).button,
                    ),
                    titlePadding: 8.0,
                    textStyle: getText(context).bodySmall,
                    activeTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                    borderColor:getColor(context).inversePrimary,
                    activeBorderColor: getColor(context).onTertiaryContainer,
                    backgroundColor: Colors.transparent,
                    activeBackgroundColor: getColor(context).primary,
                    firstTime: TimeOfDay(hour: 8, minute: 00),
                    lastTime: TimeOfDay(hour: 20, minute: 00),
                    initialRange: _timeRange,
                    timeStep: 10,
                    timeBlock: 30,
                    onRangeCompleted: (range) => setState(() => _timeRange = range),
                  ),
                ),
                SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
                          child: Text('Submit'),
                        ),
                        onPressed: () =>
                            setState(() => _timeRange = _defaultTimeRange),

                      ),
                    ),
                  )

              ],
            ),








            

          ],
        ),

      ),
    );
  }
}
