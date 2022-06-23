import '../controllers/student.dart';
import 'biodata.dart';

class Student extends Bio {
  Student(
      {required icNumber,
      required this.studentClass,
      required this.section,
      required name,
      required email,
      required this.parent,
      required this.siblings,
      required gender,
      address})
      : super(name: name, email: email, entityType: EntityType.student, icNumber: icNumber, address: address, gender: gender);

  String studentClass;
  String section;
  List<String> parent;
  List<String> siblings;

  Bio get bio => this;
  StudentController get controller => StudentController(this);
  factory Student.fromJson(Map<String, dynamic> json) => Student(
        icNumber: json["ic"],
        studentClass: json["class"],
        section: json["section"],
        address: json["address"],
        name: json["name"],
        email: json["email"] ?? '',
        gender: json["gender"] == null ? Gender.male : Gender.values.elementAt(json["gender"]),
        parent: json["parent"] == null ? [] : List<String>.from(json["parent"].map((x) => x)),
        siblings: json["siblings"] == null ? [] : List<String>.from(json["siblings"].map((x) => x)),
      );

  @override
  Map<String, dynamic> json() => {
        "ic": icNumber,
        "class": studentClass,
        "section": section,
        "name": name,
        "email": email,
        "parent": List<dynamic>.from(parent.map((x) => x)),
        "siblings": siblings,
      };
}
