// To parse this JSON data, do
//
//     final questionsModel = questionsModelFromJson(jsonString);

import 'dart:convert';

import 'package:polls_app/models/options_model.dart';

QuestionsModel questionsModelFromJson(String str) =>
    QuestionsModel.fromJson(json.decode(str));

String questionsModelToJson(QuestionsModel data) => json.encode(data.toJson());

class QuestionsModel {
  QuestionsModel({
    this.id,
    this.pollId,
    this.question,
    this.type,
    this.required,
    this.options
  });

  int? id;
  int? pollId;
  String? question;
  String? type;
  int? required;
  List<OptionsModel>? options;

  factory QuestionsModel.fromJson(Map<String, dynamic> json) => QuestionsModel(
        id: json["id"],
        pollId: json["poll_id"],
        question: json["question"],
        type: json["type"],
        required: json["required"],
        options: List<OptionsModel>.from(json["options"].map((x) => OptionsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poll_id": pollId,
        "question": question,
        "type": type,
        "required": required,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}
