import 'package:flutter/material.dart';
import 'package:tarefas/common/confirmation_dialog.dart';
import 'package:tarefas/models/task.dart';
import 'package:tarefas/services/auth_service.dart';
import 'package:tarefas/services/task_service.dart';
import '../widgets/difficultyWidget.dart';

// ignore: must_be_immutable
class TaskWidget extends StatefulWidget {
  final String idTask;
  final String nameTask;
  final String imageUrl;
  final int difficulty;
  int level;
  TaskWidget(
      {super.key,
      required this.idTask,
      required this.nameTask,
      required this.imageUrl,
      required this.difficulty,
      this.level = 0});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TaskService service = TaskService();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    int level = widget.level;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          editar();
        },
        child: Stack(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Column(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 75,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (widget.imageUrl.contains('http')
                                  ? Image.network(
                                      widget.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/images/nophoto.png',
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : Image.asset(
                                      widget.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/images/nophoto.png',
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 210,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.nameTask,
                                    style: const TextStyle(
                                        fontSize: 26,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  DifficultyStarsWidget(
                                    difficulty: widget.difficulty,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.only(left: 8, right: 8))),
                            onPressed: () {
                              setState(() {
                                widget.level++;
                                authService
                                    .getInstanceSharedPreferences()
                                    .then((prefs) {
                                  String? token = prefs.getString('token');
                                  int? userId = prefs.getInt('userId');
                                  if (token != null && userId != null) {
                                    service.edit(
                                        Task(
                                          nameTask: widget.nameTask,
                                          idTask: widget.idTask,
                                          difficulty: widget.difficulty,
                                          imageUrl: widget.imageUrl,
                                          level: widget.level,
                                          userId: userId,
                                        ),
                                        token);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'É necessário realizar um novo login.'),
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(
                                        context, 'login');
                                  }
                                });
                              });
                            },
                            child: const Text(
                              'Melhorar',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showConfirmationDialog(
                                context: context,
                                content:
                                    'Tem certeza que deseja exluir essa terefa?',
                              ).then((value) {
                                if (value) {
                                  apagar(widget.idTask);
                                }
                              });
                            },
                            child: const Text('Excluir'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          color: Colors.white,
                          value: (level / widget.difficulty) / 10,
                        ),
                      ),
                      Text(
                        'Nível: ${widget.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  editar() {
    Map<String, dynamic> arguments = {};
    arguments['idTask'] = widget.idTask;
    arguments['nameTask'] = widget.nameTask;
    arguments['imageUrl'] = widget.imageUrl;
    arguments['difficulty'] = widget.difficulty;
    arguments['context'] = context;
    Navigator.pushNamed(context, 'edit-task', arguments: arguments)
        .then((value) {
      setState(() {});
    });
  }

  apagar(String id) {
    authService.getInstanceSharedPreferences().then((prefs) {
      String? token = prefs.getString('token');
      if (token != null) {
        service.delete(id, token).then((value) {});
      }
    });
  }
}
