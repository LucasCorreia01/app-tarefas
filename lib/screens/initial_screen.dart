import 'package:flutter/material.dart';
import 'package:tarefas/screens/home_screen/home_screen_list.dart';
import 'package:tarefas/services/auth_service.dart';
import 'package:tarefas/services/task_service.dart';
import '../models/task.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  TaskService service = TaskService();
  final ScrollController _listController = ScrollController();
  Map<String, Task> database = {};
  AuthService authService = AuthService();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ListTile(
              title: const Text('Sair'),
              onTap: () {
                logout();
              },
            ),
          )
        ],
      )),
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                refresh();
              });
            },
            icon: const Icon(
              Icons.refresh,
            ),
          )
        ],
      ),
      body: ListView(
        controller: _listController,
        children: generateListTask(database: database),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'add-task').then((value) {
            setState(() {
              refresh();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void refresh() async {
    authService.getInstanceSharedPreferences().then(
      (prefs) {
        String? token = prefs.getString('token');
        int? userId = prefs.getInt('userId');
        if (token != null && userId != null) {
          service.getAll(token, userId).then(
            (List<Task> listTask) {
              setState(
                () {
                  database = {};
                  for (Task task in listTask) {
                    database[task.idTask] = task;
                  }
                },
              );
            },
          ).onError(
            (error, stackTrace) {
              logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Seu token expirou. Necessário fazer outro login.',
                  ),
                ),
              );
            },
            test: (error) => error is InvalidTokenException,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('É necessário realizar um novo login.'),
            ),
          );
          Navigator.pushReplacementNamed(context, 'login');
        }
      },
    );
  }

  void logout() {
    authService.getInstanceSharedPreferences().then((prefs) {
      prefs.clear();
      Navigator.pushReplacementNamed(context, 'login');
    });
  }
}
