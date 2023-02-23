import 'dart:core';

class ToDo {
  String? uuid;
  String? title;
  String? startDate;
  String? endDate;
  bool completed = false;

  ToDo({
    this.uuid,
    this.title,
    this.startDate,
    this.endDate,
    this.completed = false,
  });

  ToDo.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['title'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        completed = json['completed'];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'completed': completed,
    };
  }
}