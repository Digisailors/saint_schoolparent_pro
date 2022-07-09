import 'package:saint_schoolparent_pro/models/biodata.dart';

enum Audience { single, teachers, parents, admins, all }

class Post {
  final String? docId;
  final Audience audience;
  final Bio? sentTo;
  final Bio? postBy;
  final String content;
  final String title;
  final String? contentImage;
  final List<Attachment> attachments;
  final DateTime date;
  Post({
    this.docId,
    required this.audience,
    this.sentTo,
    this.postBy,
    required this.content,
    required this.title,
    this.contentImage,
    required this.attachments,
    required this.date,
  });

  factory Post.fromJson(json, docId) => Post(
        docId: docId,
        audience: Audience.values.elementAt(json["audience"]),
        sentTo: json["sentTo"] == null ? null : Bio.fromBioJson(json["sentTo"]),
        postBy: json["postBy"],
        content: json["content"],
        attachments: getAttachments(json["attachments"]),
        title: json["title"],
        contentImage: json["contentImage"],
        date: json["date"]?.toDate(),
      );

  static List<Attachment> getAttachments(List<dynamic> attachments) {
    List<Attachment> returns = [];
    for (var attachment in attachments) {
      returns.add(Attachment.fromJson(attachment));
    }
    return returns;
  }

  Map<String, dynamic> toJson() {
    return {
      "docId": docId,
      "audience": audience.index,
      "sentTo": sentTo?.toBioJson(),
      "postBy": postBy,
      "content": content,
      "attachments": attachments.map((e) => e.toJson()).toList(),
      "title": title,
      "contentImage": contentImage,
      "date": date,
    };
  }
}

class Attachment {
  final String name;
  String url;
  final AttachmentLocation attachmentLocation;
  Attachment({required this.name, required this.url, required this.attachmentLocation});

  toJson() => {
        'name': name,
        'url': url,
      };
  factory Attachment.fromJson(json) => Attachment(
        name: json['name'],
        url: json['url'],
        attachmentLocation: AttachmentLocation.cloud,
      );
}

enum AttachmentLocation { local, cloud }
