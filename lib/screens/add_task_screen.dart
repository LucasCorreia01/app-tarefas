import 'package:flutter/material.dart';
import 'package:tarefas/models/task.dart';
import 'package:tarefas/services/auth_service.dart';
import 'package:tarefas/services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  final dynamic context;
  final bool isEditing;
  final String idTask;
  final String nameTask;
  final String imageUrl;
  final int difficulty;
  final int userId;
  final int level;

  const AddTaskScreen({
    super.key,
    required this.context,
    this.isEditing = false,
    this.idTask = '',
    this.nameTask = '',
    this.imageUrl = '',
    this.difficulty = 0,
    this.userId = 0,
    this.level = 0,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  TaskService service = TaskService();

  Map<String, dynamic> map = {};

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      _nameController.text = widget.nameTask;
      _difficultyController.text = "${widget.difficulty}";
      _imageController.text = widget.imageUrl;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova tarefa',
        ),
        actions: [
          IconButton(
            onPressed: () {
              saveOrRegister();
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  border: Border.all(width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 400,
                height: 670,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira um nome.';
                          }
                          return null;
                        },
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Nome',
                            hintStyle: const TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _difficultyController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null) {
                            int inputValue;
                            try {
                              inputValue = int.parse(value);
                              if (inputValue >= 1 && inputValue <= 5) {
                                return null;
                              }
                              return 'Insira um valor numérico entre 1 e 5';
                            } on FormatException {
                              return 'Insira um valor numérico entre 1 e 5';
                            }
                          }
                          return 'Insira um valor entre 1 e 5';
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Dificuldade',
                          hintStyle: const TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value != null && value.contains('http')) {
                            return null;
                          }
                          return 'Insira uma URL de imagem válida!';
                        },
                        controller: _imageController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Imagem',
                          hintStyle: const TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 75,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(_imageController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/images/nophoto.png')),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveOrRegister();
                        }
                      },
                      child: Text(
                        widget.isEditing ? 'Salvar' : 'Adicionar',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  saveOrRegister() {
    AuthService authService = AuthService();

    authService.getInstanceSharedPreferences().then(
      (prefs) {
        String? token = prefs.getString('token');
        int? userId = prefs.getInt('userId');
        if (token != null && userId != null) {
          if (widget.isEditing) {
            service
                .edit(
                    Task.edit(
                        idTask: widget.idTask,
                        nameTask: _nameController.text,
                        difficulty: int.parse(_difficultyController.text),
                        imageUrl: _imageController.text,
                        userId: userId,
                        level: widget.level),
                    token)
                .then((value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tarefa editada com sucesso!'),
                  ),
                );
                Navigator.pop(context);
              }
            });
          } else {
            service
                .save(
                    Task(
                        nameTask: _nameController.text,
                        difficulty: int.parse(_difficultyController.text),
                        imageUrl: _imageController.text,
                        userId: userId),
                    token)
                .then((value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Nova tarefa salva com sucesso')));
                Navigator.pop(context);
              }
            });
          }
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
}
