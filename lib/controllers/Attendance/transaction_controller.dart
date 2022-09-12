// ignore_for_file: constant_identifier_names, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:saint_schoolparent_pro/firebase.dart';

import '../../models/Attendance/transaction.dart';
import 'package:http/http.dart' as http;

String USERNAME = 'admin';
String PASSWORD = 'Admin1040@';
String HOST = 'http://f0270f046de7.sn.mynetname.net:81';

class TransactionController {
  static String token = '';

  static Future<void> loadCredentials() {
    return firestore.collection('dashboard').doc('configuration').get().then((value) {
      var config = value.data();
      print(config);
      if (config != null) {
        USERNAME = config['USERNAME'];
        PASSWORD = config['PASSWORD'];
        HOST = config['HOST'];
      }
    });
  }

  static Future<void> loadToken() async {
    // var calable = functions.httpsCallable('loadToken');
    // return calable.call().then((value) {
    //   token = value.data;
    //   print(token);
    // });

    var headers = {'content-type': 'application/json'};
    print("=>  HOST : $HOST");
    var request = http.Request('POST', Uri.parse('$HOST/jwt-api-token-auth/'));
    request.body = json.encode({"username": USERNAME, "password": PASSWORD});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      token = jsonResponse['token'];
      print(token);
    } else {
      print(response.reasonPhrase);
    }
  }

  static bool isSameDay(DateTime? dateA, DateTime? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }

  static Future<List<StudentAttendanceByDate>> getTransactions(
      Map<String, dynamic> map) {
    return loadTransactions(
        startTime: map['startTime'],
        endTime: map['endTime'],
        empCode: map['empCode']);
  }

  static Future<List<StudentAttendanceByDate>> loadTransactions(
      {required DateTime startTime,
      required DateTime endTime,
      required String empCode}) async {
    List<StudentAttendanceByDate> transactionLogs = [];
    endTime = endTime.add(const Duration(days: 1));
    Map<String, dynamic> maplogs;
    await loadToken();
    var headers = {'Authorization': 'JWT $token'};
    var url =
        '$HOST/iclock/api/transactions/?emp_code=$empCode&start_time=${startTime.toString().substring(0, 19)}&end_time=${endTime.toString().substring(0, 19)}&page_size=1000';
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var unParsedLogs = body['data'];
      if (unParsedLogs is List) {
        // var unParsedLogs = body['data'];
        List<TransactionLog> logs =
            unParsedLogs.map((e) => TransactionLog.fromJson(e)).toList();
        var diffInDays = endTime.difference(startTime).inDays;
        for (int i = 0; i < diffInDays; i++) {
          var date = startTime.add(Duration(days: i));
          print(date.toString());
          DateTime? checkInTime;
          DateTime? checkOutTime;
          // bool cafeteria = false;
          var tempLogs;
          try {
            tempLogs =
                logs.where((element) => element.punchDate == date).toList();
          } catch (e) {
            print(e.toString());
          }
          for (var tempLog in tempLogs) {
            if (tempLog.areaAlias != 'CAFETERIA') {
              // cafeteria = true;
              if (tempLog.punchState == '0') {
                checkInTime = checkInTime == null
                    ? tempLog.punchTime
                    : checkInTime.isBefore(tempLog.punchTime)
                        ? checkInTime
                        : tempLog.punchTime;
              }
              if (tempLog.punchState == '1') {
                checkOutTime = checkOutTime == null
                    ? tempLog.punchTime
                    : checkOutTime.isAfter(tempLog.punchTime)
                        ? checkOutTime
                        : tempLog.punchTime;
              }
            }
          }
          transactionLogs.add(StudentAttendanceByDate(
              date: date,
              checkInTime: checkInTime,
              checkOutTime: checkOutTime));
        }
      }
      print(body);
      return transactionLogs;
    } else {
      return transactionLogs;
    }
  }

  // static List<TransactionLog> transactionLogs = [];

  // static Future<List<TransactionLog>> loadTransactions({DateTime? startTime, DateTime? endTime, String? empCode, required int? entity}) async {
  //   List<TransactionLog> transactionLogs = [];
  //   var callable = functions.httpsCallable('getTransaction');
  //   var data = {
  //     'token': token,
  //     'start_time': startTime?.toString().substring(0, 19),
  //     'end_time': endTime?.toString().substring(0, 19),
  //     'emp_code': empCode,
  //     'entity': entity
  //   };
  //   try {

  //     return callable.call(data).then((response) {
  //       var value = response.data;
  //       if (value is List) {
  //         transactionLogs = value.map((e) => TransactionLog.fromJson(e)).toList();
  //       }
  //       return transactionLogs;
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //     return transactionLogs;
  //   }
  // }
}

class StudentAttendanceByDate {
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  // final bool cafeteria;

  StudentAttendanceByDate({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    // required this.cafeteria,
  });
}
