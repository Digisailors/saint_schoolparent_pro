import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/models/Attendance/transaction.dart';
import 'package:saint_schoolparent_pro/models/student.dart';

class StudentTransaction {
  final Student student;

  final List<TransactionLog> logs;

  static List<TransactionLog> getMyTransactionLog({required Student student, required List<TransactionLog> logs}) {
    List<TransactionLog> mylogs = logs.where((element) => element.empCode == student.icNumber && element.areaAlias != 'CAFETERIA').toList();
    mylogs.sort(((a, b) => b.punchTime.compareTo(a.punchTime)));
    print(' count  :  ${mylogs.where((element) => element.checkOutStatus != null).length}');
    return mylogs;
  }

  StudentTransaction(this.student, this.logs);

  factory StudentTransaction.create(Student student, List<TransactionLog> logs) {
    var studentTransaction = StudentTransaction(student, logs);

    var checkIntransaction = logs.firstWhereOrNull((element) => element.punchState == "0");
    studentTransaction.checkInTime = checkIntransaction?.punchTime;
    studentTransaction.checkInStatus = checkIntransaction?.checkInStatus;

    var list = logs.where((element) => element.punchState == "1");
    var checkOutTransaction = list.isEmpty ? null : list.last;
    studentTransaction.checkOutTime = checkOutTransaction?.punchTime;
    studentTransaction.checkOutStatus = checkOutTransaction?.checkOutStatus;
    if (student.name == 'BRUCE BANNER') {
      print(studentTransaction.checkOutStatus);
    }
    return studentTransaction;
  }

  CheckInStatus? checkInStatus;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  CheckOutStatus? checkOutStatus;
}
