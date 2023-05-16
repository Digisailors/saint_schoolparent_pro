import 'biodata.dart';
import 'parent.dart';

class Student extends Bio {
  Student({
    required String icNumber,
    required this.studentClass,
    required this.section,
    required String name,
    required String email,
    required Gender gender,
    required this.father,
    required this.guardian,
    required this.mother,
    String? address,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? imageUrl,
    String? lastName,
    String? primaryPhone,
    String? secondaryPhone,
    String? state,
    String? fcm,
    required this.docId,
  }) : super(
          fcm: fcm,
          name: name,
          email: email,
          entityType: EntityType.student,
          icNumber: icNumber,
          address: address,
          gender: gender,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          imageUrl: imageUrl,
          lastName: lastName,
          primaryPhone: primaryPhone,
          secondaryPhone: secondaryPhone,
          state: state,
        );

  String studentClass;
  String section;

  String docId;
  Parent? father;
  Parent? mother;
  Parent? guardian;

  List<String> get parents {
    List<String> result = [];
    if (father != null) {
      result.add(father!.icNumber);
    }
    if (mother != null) {
      result.add(mother!.icNumber);
    }
    if (guardian != null) {
      result.add(guardian!.icNumber);
    }
    return result;
  }

  Bio get bio => this;
  factory Student.fromJson(Map<String, dynamic> json) => Student(
        docId: json["docId"],
        icNumber: json["icNumber"],
        name: json["name"],
        email: json["email"] ?? '',
        gender: json["gender"] == null ? Gender.male : Gender.values.elementAt(json["gender"]),
        address: json["address"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        city: json["city"],
        imageUrl: json["imageUrl"],
        lastName: json["lastName"],
        primaryPhone: json["primaryPhone"],
        secondaryPhone: json["secondaryPhone"],
        state: json["state"],
        //-------------------------------------------
        father: json["father"] != null ? Parent.fromJson(json['father']) : null,
        guardian: json["guardian"] != null ? Parent.fromJson(json['guardian']) : null,
        mother: json["mother"] != null ? Parent.fromJson(json['mother']) : null,
        //-------------------------------------------
        studentClass: json["class"],
        section: json["section"],
      );

  Map<String, dynamic> toJson() => {
        "docId": docId,
        "icNumber": icNumber,
        "name": name,
        "email": email,
        "gender": gender.index,
        "entityType": entityType.index,
        "address": address,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "imageUrl": imageUrl,
        "lastName": lastName,
        "primaryPhone": primaryPhone,
        'secondaryPhone': secondaryPhone,
        "state": state,
        "search": search,
        "nonHyphenIcNumber": nonHyphenIcNumber,
        //------------
        "father": father?.toJson(),
        "mother": mother?.toJson(),
        "guardian": guardian?.toJson(),
        //------------
        "class": studentClass,
        "section": section,
        //------------
        "parents": parents,
      };
}
