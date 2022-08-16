class Notification {
  Notification({
    required this.description,
    this.documentPath,
    required this.title,
    required this.time,
    required this.route,
  });

  String description;
  String? documentPath;
  String title;
  DateTime time;
  String? route;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        description: json["description"],
        documentPath: json["document"],
        title: json["title"],
        time: DateTime.parse(json["time"]),
        route: json["route"],
      );

  factory Notification.fromStringList(List<String> json) => Notification(
        title: json[0],
        description: json[1],
        time: DateTime.parse(json[2]),
        route: json[3],
        documentPath: json[4],
      );

  toStringList() {
    return [title, description, time, route, documentPath];
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "document": documentPath,
        "title": title,
        "time": time,
        "route": route,
      };
}
