import 'package:flutter/cupertino.dart';

import '../models/task_model.dart';
import '../repositories/contact_repository.dart';
import '../services/sql_data_base.dart';

class TaskController extends ChangeNotifier {
  TarefaSQLiteRepository tarefaSQLiteRepository = TarefaSQLiteRepository();

  List<TaskModel> tarefas = [];

  Future<void> obterDados(bool apenasNaoConcluidos) async {
    var db = await SQLiteDataBase().obterDataBase();
    var result = await db.rawQuery(
        apenasNaoConcluidos ? "SELECT id, description, concluded FROM tasks WHERE concluded = 0" : 'SELECT id, description, concluded FROM tasks');
    for (var element in result) {
      tarefas.add(TaskModel(
        id: element["id"].toString(),
        element["description"].toString(),
        element["concluded"] == 1,
      ));
    }
    notifyListeners();
  }

  Future<void> salvar(TaskModel tarefaSQLiteModel) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawInsert('INSERT INTO tasks (description, concluded) values(?,?)', [tarefaSQLiteModel.description, tarefaSQLiteModel.concluded]);
    notifyListeners();
  }

  Future<void> atualizar(TaskModel tarefaSQLiteModel) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawInsert('UPDATE tasks SET description = ?, concluded = ? WHERE id = ?',
        [tarefaSQLiteModel.description, tarefaSQLiteModel.concluded ? 1 : 0, tarefaSQLiteModel.id]);
    notifyListeners();
  }

  Future<void> remover(int id) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawInsert('DELETE FROM tasks WHERE id = ?', [id]);
  }
}
