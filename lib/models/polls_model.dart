// To parse this JSON data, do
//
//     final pollsModel = pollsModelFromJson(jsonString);

import 'dart:convert';

PollsModel pollsModelFromJson(String str) =>
    PollsModel.fromJson(json.decode(str));

String pollsModelToJson(PollsModel data) => json.encode(data.toJson());

class PollsModel {
  PollsModel({
    this.id,
    this.userId,
    this.pollReason,
    this.pollSubtitle,
    this.expectedSamplings,
    this.totalSamplings,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? pollReason;
  String? pollSubtitle;
  int? expectedSamplings;
  int? totalSamplings;
  int? active;
  dynamic createdAt;
  dynamic updatedAt;

  factory PollsModel.fromJson(Map<String, dynamic> json) => PollsModel(
        id: json["id"],
        userId: json["user_id"],
        pollReason: json["poll_reason"],
        pollSubtitle: json["poll_subtitle"],
        expectedSamplings: json["expected_samplings"],
        totalSamplings: json["total_samplings"],
        active: json["active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "poll_reason": pollReason,
        "poll_subtitle": pollSubtitle,
        "expected_samplings": expectedSamplings,
        "total_samplings": totalSamplings,
        "active": active,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Polls {
  List<PollsModel> items = [];

  Polls();

  Polls.fromJsonList(List<dynamic> jsonList) {
    // if(jsonList == null) return;

    for (var item in jsonList) {
      final poll = new PollsModel.fromJson(item);
      items.add(poll);
    }
  }
}
