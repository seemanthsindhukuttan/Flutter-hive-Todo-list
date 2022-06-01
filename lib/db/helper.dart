import 'package:hive_flutter/adapters.dart';

class HiveHelper {
  // open box.
  static final _todoBox = Hive.box("TodoBox");
  //read data.
  static List<Map<String, dynamic>> getTodo() {
    var todobox = _todoBox.keys.map((key) {
      var value = _todoBox.get(key);
      return {
        "key": key,
        "title": value['title'],
        "description": value['description'],
      };
    }).toList();
    return todobox;
  }

  // add to box.
  static Future<void> addTodo(Map<String, dynamic> newTodo) async {
    await _todoBox.add(newTodo);
  }

  //update.
  static Future<void> updateTodo(
      int todoKey, Map<String, dynamic> oldTodo) async {
    await _todoBox.put(todoKey, oldTodo);
  }

  //delete
  static Future<void> deleteTodo(int todoKey) async {
    await _todoBox.delete(todoKey);
  }
}
