import 'dart:async';

import 'package:sqflite/sqflite.dart';

/// `todo` table name
const String tableTodo = 'todo';

/// id column name
const String columnId = '_id';

/// title column name
const String columnTitle = 'title';

/// done column name
const String columnDone = 'done';

/// Todo model.
class Todo {
  /// Todo model.
  Todo();

  /// Read from a record.
  Todo.fromMap(Map map) {
    id = map[columnId] as int?;
    title = map[columnTitle] as String?;
    done = map[columnDone] == 1;
  }

  /// id.
  int? id;

  /// title.
  String? title;

  /// done.
  bool? done;

  /// Convert to a record.
  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

/// Todo provider.
class TodoProvider {
  /// The database when opened.
  late Database db;

  /// Open the database.
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDone integer not null)
''');
    });
  }

  /// Insert a todo.
  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  /// Get a todo.
  Future<Todo?> getTodo(int id) async {
    final List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  /// Delete a todo.
  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  /// Update a todo.
  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id!]);
  }

  /// Close database.
  Future close() async => db.close();
}
