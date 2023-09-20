import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController{
  final taskList = <Task>[].obs;

  Future<int> addTask({Task? task,}){
    return DBHelper.insert(task!);
  }

  Future<void> getTasks()async{
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  void deleteTasks({Task? task})async{
    await DBHelper.delete(task!);
    getTasks();
  }

  void deleteAllTasks()async{
    await DBHelper.deleteAll();
    getTasks();
  }

  void markUsCompletedTasks(int id)async{
    await DBHelper.update(id);
    getTasks();
  }
}
