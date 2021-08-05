// To parse this JSON data, do
//
//     final optionsModel = optionsModelFromJson(jsonString);

import 'dart:convert';

OptionsModel optionsModelFromJson(String str) => OptionsModel.fromJson(json.decode(str));

String optionsModelToJson(OptionsModel data) => json.encode(data.toJson());

class OptionsModel {
    OptionsModel({
        this.id,
        this.questionId,
        this.option,
    });

    int? id;
    int? questionId;
    String? option;

    factory OptionsModel.fromJson(Map<String, dynamic> json) => OptionsModel(
        id: json["id"],
        questionId: json["question_id"],
        option: json["option"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "option": option,
    };
}
