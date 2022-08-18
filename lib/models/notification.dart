class NotificationLog {
  NotificationLog({
    required this.description,
    this.documentPath,
    required this.title,
    required this.time,
    required this.route,
    required this.messageId,
  });

  String description;
  String? documentPath;
  String title;
  DateTime time;
  String? route;
  String? messageId;

  factory NotificationLog.fromJson(Map<String, dynamic> json, messageId) => NotificationLog(
        messageId: messageId,
        description: json["description"],
        documentPath: json["document"],
        title: json["title"],
        time: DateTime.parse(json["time"]),
        route: json["route"],
      );

  factory NotificationLog.fromStringList(List<String> json, messageId) => NotificationLog(
        messageId: messageId,
        title: json[0],
        description: json[1],
        time: DateTime.parse(json[2]),
        route: json[3],
        documentPath: json[4],
      );

  List<String> toStringList() {
    return [title, description, time.toIso8601String(), route ?? '', documentPath ?? ''];
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "document": documentPath,
        "title": title,
        "time": time,
        "route": route,
      };
}
