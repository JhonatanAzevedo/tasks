import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'controller/task_controller.dart';
import 'models/task_model.dart';
import 'repositories/contact_repository.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<TaskController>(create: (_) => TaskController())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TarefaProviderPage(),
      ),
    );
  }
}

class TarefaProviderPage extends StatefulWidget {
  const TarefaProviderPage({super.key});

  @override
  State<TarefaProviderPage> createState() => _TarefaProviderPageState();
}

class _TarefaProviderPageState extends State<TarefaProviderPage> {
  final descriptionController = TextEditingController();
  TarefaSQLiteRepository tarefaSQLiteRepository = TarefaSQLiteRepository();
  List<TaskModel> tasks = [];
  var apenasNaoConcluidos = false;

  @override
  void initState() {
    super.initState();
    Provider.of<TaskController>(context, listen: false).obterDados(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicione suas tarefas'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          descriptionController.text = "";
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: const Text("Adicionar tarefa"),
                  content: TextField(
                    controller: descriptionController,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () async {
                          Provider.of<TaskController>(context, listen: false).salvar(TaskModel(
                            descriptionController.text,
                            false,
                          ));
                          Navigator.pop(context);
                        },
                        child: const Text("Salvar"))
                  ],
                );
              });
        },
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Apenas não concluídos",
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                      value: apenasNaoConcluidos,
                      onChanged: (bool value) {
                        apenasNaoConcluidos = value;
                      })
                ],
              ),
            ),
            Expanded(
              child: Consumer<TaskController>(
                builder: (_, taskController, widget) {
                  return ListView.builder(
                    itemCount: taskController.tarefas.length,
                    itemBuilder: (BuildContext bc, int index) {
                      var task = taskController.tarefas[index];
                      return Dismissible(
                        onDismissed: (DismissDirection dismissDirection) async {
                          Provider.of<TaskController>(context, listen: false).remover(int.parse(task.id ?? '0'));
                        },
                        key: Key(task.description),
                        child: ListTile(
                          title: Text(task.description),
                          trailing: Switch(
                            onChanged: (bool value) async {
                              task.concluded = value;
                              Provider.of<TaskController>(context, listen: false).atualizar(TaskModel(task.id ?? '0', task.concluded));
                            },
                            value: task.concluded,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
