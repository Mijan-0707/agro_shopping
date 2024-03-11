// Category table

import 'dart:async';

import 'package:sqflite/sqflite.dart';

/// `category` table name
const String tableCategory = 'category';

/// id column name
const String columnId = '_id';

/// title column name
const String columnTitle = 'title';

/// done column name
const String columnDone = 'done';

/// Category model.
class Category {
  /// Category model.
  Category();

  /// Read from a record.
  Category.fromMap(Map map) {
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

/// Category provider.
class CategoryProvider {
  /// The database when opened.
  late Database db;

  /// Open the database.
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableCategory ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDone integer not null)
''');
        });
  }

  /// Insert a category.
  Future<Category> insert(Category category) async {
    category.id = await db.insert(tableCategory, category.toMap());
    return category;
  }

  /// Get a category.
  Future<Category?> getCategory(int id) async {
    final List<Map> maps = await db.query(tableCategory,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }

  /// Delete a category.
  Future<int> delete(int id) async {
    return await db.delete(tableCategory, where: '$columnId = ?', whereArgs: [id]);
  }

  /// Update a category.
  Future<int> update(Category category) async {
    return await db.update(tableCategory, category.toMap(),
        where: '$columnId = ?', whereArgs: [category.id!]);
  }

  /// Close database.
  Future close() async => db.close();
}
