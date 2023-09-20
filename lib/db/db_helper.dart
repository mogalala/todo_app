import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('Not null Database');
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'task.db';
      debugPrint('In Database Path');
      _db = await openDatabase(_path, version: _version, onCreate: (Database db, int version) async {
        debugPrint('Creating anew one');
        await db.execute(
          'CREATE TABLE $_tableName ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title STRING, note TEXT, date STRING, '
          'startTime STRING, endTime STRING, remind INTEGER, repeat STRING, '
          'color INTEGER, isCompleted INTEGER)',
        );
      });
      debugPrint('Database Created');
    } catch (error) {
      print('///////////// $error');
    }
  }

  static Future<int> insert(Task task) async {
    print('////// INSERT Function Called');
    try{
      return await _db!.insert(_tableName, task.toJson());
    }catch(e){
      print('////////$e');
      return 400;
    }
  }

  static Future<int> delete(Task task) async {
    print('////// DELETE Function Called');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    print('////// DELETE All Function Called');
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('////// QUERY Function Called');
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print('////// UPDATE Function Called');
    return await _db!.rawUpdate('''
    UPDATE tasks SET isCompleted = ? where id = ? 
    ''', [1, id]);
  }
}
