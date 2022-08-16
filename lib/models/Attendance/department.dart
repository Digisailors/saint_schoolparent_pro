import 'package:get/get.dart';

class Department {
  Department({
    this.id,
    // required this.deptCode,
    required this.deptName,
    required this.parentDept,
  });

  int? id;
  String get deptCode => deptName.removeAllWhitespace + (parentDept == 2 ? '' : parentDept.toString());
  String deptName;
  int parentDept;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    if (other is Department) {
      return id == other.id;
    }
    return false;
  }

  get codePrefix => parentDept == 2 ? 'CLASS' : 'SECTION';

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json['id'],
        // deptCode: json["dept_code"],
        deptName: json["dept_name"],
        parentDept: json["parent_dept"] is int ? json["parent_dept"] : json["parent_dept"]!["id"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dept_code": deptCode,
        "dept_name": deptName,
        "parent_dept": parentDept,
      };
}
