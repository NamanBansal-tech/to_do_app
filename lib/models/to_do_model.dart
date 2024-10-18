import 'dart:convert';

/// title : "to do task"
/// isCompleted : false

ToDoModel toDoModelFromJson(String str) => ToDoModel.fromJson(json.decode(str));

String toDoModelToJson(ToDoModel data) => json.encode(data.toJson());

class ToDoModel {
  ToDoModel({
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    _title = title;
    _id = id;
    _isCompleted = isCompleted;
  }

  ToDoModel.fromJson(dynamic json) {
    _title = json['title'];
    _id = json['id'];
    _isCompleted = json['isCompleted'];
  }

  String? _title;
  int? _id;
  bool? _isCompleted;

  ToDoModel copyWith({
    String? title,
    int? id,
    bool? isCompleted,
  }) =>
      ToDoModel(
        title: title ?? _title,
        id: id ?? _id,
        isCompleted: isCompleted ?? _isCompleted,
      );

  String? get title => _title;

  int? get id => _id;

  bool? get isCompleted => _isCompleted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['id'] = _id;
    map['isCompleted'] = _isCompleted;
    return map;
  }
}
