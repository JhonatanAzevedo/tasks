import 'package:flutter/cupertino.dart';

class TaskModel {
  String? id = UniqueKey().toString();
  String description;
  bool concluded;

    TaskModel(this.description, this.concluded, {String? id}) {
    this.id = id ?? UniqueKey().toString();
  }
}
