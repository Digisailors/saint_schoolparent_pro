// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

TransactionLog transactionFromJson(String str) => TransactionLog.fromJson(json.decode(str));

// String transactionToJson(TransactionLog data) => json.encode(data.toJson());

enum CheckInStatus { late, onTime }

enum CheckOutStatus { early, onTime }

class TransactionLog {
  TransactionLog({
    required this.id,
    required this.empCode,
    required this.firstName,
    this.lastName,
    required this.punchTime,
    required this.punchState,
    this.punchStateDisplay,
    this.areaAlias,
  });

  int id;
  String empCode;
  String firstName;
  String? lastName;
  DateTime punchTime;
  String punchState;
  String? punchStateDisplay;
  dynamic areaAlias;

  DateTime get punchDate => DateTime(punchTime.year, punchTime.month, punchTime.day);

  CheckInStatus? get checkInStatus {
    if (punchState == '0') {
      var duration = punchTime.difference(DateTime(punchTime.year, punchTime.month, punchTime.day, 9, 0));
      if (duration.inMinutes < 0) {
        return CheckInStatus.onTime;
      } else {
        return CheckInStatus.late;
      }
    }
    return null;
  }

  CheckOutStatus? get checkOutStatus {
    if (punchState == '1') {
      var duration = punchTime.difference(DateTime(punchTime.year, punchTime.month, punchTime.day, 16, 30));
      if (duration.inMinutes > 0) {
        return CheckOutStatus.onTime;
      } else {
        return CheckOutStatus.early;
      }
    }
    return null;
  }

  factory TransactionLog.fromJson(Map<String, dynamic> json) => TransactionLog(
        id: json["id"],
        empCode: json["emp_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        punchTime: DateTime.parse(json["punch_time"]),
        punchState: json["punch_state"],
        punchStateDisplay: json["punch_state_display"],
        areaAlias: json["area_alias"],
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "emp_code": empCode,
  //       "first_name": firstName,
  //       "last_name": lastName,

  //       "punch_time": punchTime.toIso8601String(),
  //       "punch_state": punchState,
  //       "punch_state_display": punchStateDisplay,
  //       "verify_type": verifyType,
  //       "verify_type_display": verifyTypeDisplay,
  //       "work_code": workCode,
  //       "gps_location": gpsLocation,
  //       "area_alias": areaAlias,
  //       "terminal_sn": terminalSn,
  //       "temperature": temperature,
  //       "terminal_alias": terminalAlias,
  //       "upload_time": uploadTime.toString(),
  //     };
}
