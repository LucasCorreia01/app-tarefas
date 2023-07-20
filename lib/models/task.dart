import 'package:uuid/uuid.dart';

class Task {
  String nameTask;
  int difficulty;
  String imageUrl;
  String idTask;
  int level;
  int userId;

  Task(
      {required this.nameTask,
      required this.difficulty,
      required this.imageUrl,
      required this.userId,
      this.level = 0,
      this.idTask = ""}) {
    if (idTask == "") {
      idTask = const Uuid().v1();
    }
  }

  Task.edit({
    required this.idTask,
    required this.nameTask,
    required this.difficulty,
    required this.imageUrl,
    required this.level,
    required this.userId,
  });

  Task.empty()
      : nameTask = "",
        difficulty = 0,
        imageUrl = "",
        level = 0,
        userId = 0,
        idTask = const Uuid().v1();

  Task.fromMap(Map<String, dynamic> map)
      : nameTask = map['nameTask'],
        difficulty = int.parse(map['difficulty']),
        imageUrl = map['imageUrl'],
        idTask = map['id'],
        userId = int.parse(map['userId']),
        level = int.parse(map['level']);

  Map<String, dynamic> toMap() {
    return {
      'id': idTask,
      'nameTask': nameTask,
      'difficulty': "$difficulty",
      'imageUrl': imageUrl,
      'userId': "$userId",
      'level': "$level"
    };
  }
}
