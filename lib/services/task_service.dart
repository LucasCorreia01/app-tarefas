import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tarefas/services/auth_service.dart';
import 'web_client.dart';
import 'package:tarefas/models/task.dart';

class TaskService {
  static const String resource = "tasks/";
  var client = WebClient.client;
  AuthService authService = AuthService();

  Future<bool> save(Task task, String token) async {
    String jsonTask = json.encode(task.toMap());

    http.Response response = await client.post(
      Uri.parse('${WebClient().geturl()}$resource'),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: jsonTask,
    );

    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }

    return true;
  }

  Future<List<Task>> getAll(String token, int userId) async {
    http.Response response = await client.get(
        Uri.parse(
          '${WebClient().geturl()}users/$userId/$resource',
        ),
        headers: {"Authorization": "Bearer $token"});


    if (response.body == '"jwt expired"') {
      throw InvalidTokenException();
    }

    List<Task> result = [];

    List<dynamic> jsonList = json.decode(response.body);
    for (var jsonMap in jsonList) {
      result.add(Task.fromMap(jsonMap));
    }

    return result;
  }

  Future<bool> edit(Task task, String token) async {
    String jsonTask = json.encode(task.toMap());

    http.Response response = await client.put(
      Uri.parse('${WebClient().geturl()}$resource${task.idTask}'),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: jsonTask,
    );

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await client.delete(
      Uri.parse("${WebClient().geturl()}$resource$id"),
      headers: {"Authorization": "Bearer $token"}
    );

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<String> getToken() async {
    authService.getInstanceSharedPreferences().then((prefs) {
      String? token = prefs.getString('token');
      return token;
    });

    return 'Não foi possível recurar o token';
  }
}
