class Standard {
  Standard({required this.className, required this.section, required this.id});

  String className;
  List<String> section;
  String id;

  factory Standard.fromJson(Map<String, dynamic> json) => Standard(
        className: json["className"],
        section: List<String>.from(json["section"].map((x) => x)),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "className": className,
        "section": List<dynamic>.from(section.map((x) => x)),
      };
}
