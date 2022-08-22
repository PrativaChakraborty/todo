// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

List<Task> taskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Task({
    required this.id,
    this.body = " ",
    required this.task,
    required this.isChecked,
    this.date = " ",
    this.time = " ",
  });

  int id;
  String body;
  String task;
  bool isChecked;
  String date;
  String time;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        body: json["body"],
        task: json["task"],
        isChecked: json["isChecked"],
        date: json["date"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "task": task,
        "isChecked": isChecked,
        "date": date,
        "time": time,
      };
}
