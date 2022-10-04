import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saint_schoolparent_pro/controllers/Attendance/transaction_controller.dart';
import 'package:saint_schoolparent_pro/models/student.dart';
import 'package:saint_schoolparent_pro/theme.dart';

class StudentAttendnace extends StatefulWidget {
  const StudentAttendnace({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<StudentAttendnace> createState() => _StudentAttendnaceState();
}

class _StudentAttendnaceState extends State<StudentAttendnace> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    toDate = DateTime.now();
    fromDate = DateTime(toDate.year, toDate.month, 1);
    fromDateController.text = format.format(fromDate);
    toDateController.text = format.format(toDate);
  }

  late DateTime toDate;
  late DateTime fromDate;
  TextFormField getTextFormField(bool isFromDate) {
    return TextFormField(
      controller: isFromDate ? fromDateController : toDateController,
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () async {
                DateTime date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    ) ??
                    (isFromDate ? fromDate : toDate);

                if (isFromDate) {
                  setState(() {
                    fromDateController.text = format.format(date);
                    fromDate = date;
                  });
                } else {
                  setState(() {
                    toDateController.text = format.format(date);
                    toDate = date;
                  });
                }
              },
              icon: const Icon(Icons.calendar_month))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.student.name), actions: []),
      body: Column(children: [
        SizedBox(
          height: 120,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Hero(
                  tag: widget.student.icNumber,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: (widget.student.imageUrl != null ? NetworkImage(widget.student.imageUrl!) : const AssetImage('assets/logo.png'))
                        as ImageProvider,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      getTextFormField(true),
                      getTextFormField(false),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(child: SingleChildScrollView(
          child: Builder(builder: (context) {
            Map<String, dynamic> mapParams = {
              'empCode': widget.student.docId,
              'startTime': fromDate,
              'endTime': toDate,
            };
            return FutureBuilder<List<StudentAttendanceByDate>>(
              // future: TransactionController.loadTransactions(empCode: widget.student.icNumber, startTime: fromDate, endTime: toDate),
              future: compute(TransactionController.getTransactions, mapParams),
              builder: (BuildContext context, AsyncSnapshot<List<StudentAttendanceByDate>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: SelectableText(snapshot.error.toString()),
                  );
                }
                if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                  return Table(
                    children: [
                      TableRow(
                        children: [
                          PaginatedDataTable(
                              columns: AttendanceSource.getCoumns(), source: AttendanceSource(context: context, logs: snapshot.data ?? [])),
                        ],
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }),
        ))
      ]),
    );
  }
}

class AttendanceSource extends DataTableSource {
  final BuildContext context;
  final List<StudentAttendanceByDate> logs;
  final String? area;

  final format = DateFormat.MMMd('en_US');

  AttendanceSource({required this.context, required this.logs, this.area});
  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= logs.length) return null;
    final log = logs[index];

    var cells = [
      DataCell(Text(format.format(log.date))),
      DataCell(Text(log.checkInTime == null ? 'NO DATA' : TimeOfDay.fromDateTime(log.checkInTime!).format(context))),
      DataCell(Text(log.checkOutTime == null ? 'NO DATA' : TimeOfDay.fromDateTime(log.checkOutTime!).format(context))),
      // DataCell(Text(log.cafeteria ? 'CHECKED IN' : 'NOT CHECKED IN')),
    ];
    if (area == 'CAFETERIA') {
      cells.removeLast();
    }

    return DataRow(cells: cells, color: (index % 2 == 0) ? MaterialStateProperty.all(Colors.grey.shade200) : MaterialStateProperty.all(Colors.white));
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => logs.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  static List<DataColumn> getCoumns() {
    List<DataColumn> columns = [
      const DataColumn(label: Text('DATE')),
      const DataColumn(label: Text('CHECK IN')),
      const DataColumn(label: Text('CHECK OUT')),
      // const DataColumn(label: Text('CAFETERIA')),
    ];
    return columns;
  }
}
