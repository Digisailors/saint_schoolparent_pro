import 'package:flutter/material.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        bottom: PreferredSize(preferredSize: Size.fromHeight(50.0),child: // Generated code for this TextField Widget...
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
    child: TextFormField(

            onChanged: (_) {},
            obscureText: false,
            decoration: InputDecoration(
              labelText: 'Search products...',
              labelStyle: TextStyle(
                fontFamily: 'Outfit',
                color: Color(0xFF57636C),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Color(0xFF57636C),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Color(0xFF14181B),
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        )
          ,

        ),
      ),

      body: SingleChildScrollView(
        child: Column(

          children: [
            // Generated code for this menuItem Widget...
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Color(0x411D2429),
                      offset: Offset(0, 1),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1574914629385-46448b767aec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bGF0dGV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
                            width: 70,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How to pour Latte Art',

                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                                child: Text(
                                  'A wonderfully delicious 2 patty melt that melts into your...',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Roboto Mono',
                                    color: Color(0xFF57636C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            )

          ],
        ),



      ),


    );
  }
}
