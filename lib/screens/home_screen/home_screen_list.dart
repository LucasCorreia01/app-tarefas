import 'package:tarefas/widgets/widget_task.dart';

import '../../models/task.dart';

List<TaskWidget> generateListTask({
  required Map<String, Task> database,
}) {
  List<TaskWidget> list = [];

  database.forEach((key, value) {
    list.add(TaskWidget(
        idTask: value.idTask,
        nameTask: value.nameTask,
        difficulty: value.difficulty,
        imageUrl: value.imageUrl,
        level: value.level));
  });

  return list;
}
