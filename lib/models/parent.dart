import 'biodata.dart';

class Parent extends Bio {
  Parent({
    required icNumber,
    required email,
    required name,
    required this.children,
    required gender,
    address,
    this.uid,
  }) : super(name: name, email: email, entityType: EntityType.parent, icNumber: icNumber, address: address, gender: gender);

  List<String> children;
  String? uid;

  Bio get bio => this;

  copyWith(Parent parent) {
    gender = parent.gender;
    address = parent.address;
    uid = parent.uid;
    icNumber = parent.icNumber;
    email = parent.email;
    name = parent.name;
    children = parent.children;
  }

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
        gender: Gender.values.elementAt(json["gender"]),
        address: json["address"] ?? '',
        uid: json["uid"] ?? '',
        icNumber: json["icNumber"] ?? '',
        email: json["email"] ?? '',
        name: json["name"],
        children: List<String>.from(json["children"].map((x) => x)),
      );

  Map<String, dynamic> toJson() {
    var map = bio.json();
    map.addAll({"children": children, "uid": uid});
    return map;
  }
}
