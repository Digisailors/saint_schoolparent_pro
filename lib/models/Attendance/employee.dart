class Employee {
  Employee({
    this.id,
    required this.empCode,
    required this.department,
    required this.gender,
    this.firstName,
  });
  int? id;
  String empCode;
  int department;
  String gender;
  String? firstName;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        empCode: json["emp_code"],
        department: json["department"],
        gender: json["gender"],
        firstName: json["first_name"],
      );

  Map<String, dynamic> toJson() => {"id": id, "emp_code": empCode, "department": department, "gender": gender, "first_name": firstName};
}
