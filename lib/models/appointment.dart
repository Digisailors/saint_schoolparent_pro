import 'biodata.dart';

class Appointment {
  Appointment(
      {required this.date,
      required this.status,
      required this.approvedBy,
      required this.location,
      required this.raisedBy,
      required this.participants,
      this.id});

  String date;
  String? id;
  int status;
  String approvedBy;
  String raisedBy;
  String location;
  List<Bio> participants;

  factory Appointment.fromJson(Map<String, dynamic> json, id) => Appointment(
      id: id,
      date: json["date"],
      status: json["status"],
      approvedBy: json["approvedBy"],
      location: json["location"],
      participants: json["participants"],
      raisedBy: json["raisedBy"]);

  Map<String, dynamic> toJson() => {
        "date": date,
        "status": status,
        "approvedBy": approvedBy,
        "location": location,
        "participants": participants,
        "raisedBy": raisedBy,
      };
}
