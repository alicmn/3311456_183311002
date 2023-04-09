import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/data/base_database';

class NoteDataBase extends BaseDatabase {
  List toDoList = [];

  final _noteBox = Hive.box('mybox');

  @override
  void createInitialData() {
    toDoList = [
      ["Vize Ödevini Tamamla", false],
      ["Spor Yap", false],
    ];
  }

  @override
  void loadData() {
    toDoList = _noteBox.get("TODOLIST");
  }

  @override
  void updateDatabase() {
    _noteBox.put("TODOLIST", toDoList);
  }
}
