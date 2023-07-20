import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/services/web_client.dart';

class AuthService {
  var client = WebClient.client;

  Future<SharedPreferences> getInstanceSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> register(String email, String password) async {
    http.Response response = await client.post(
      Uri.parse("${WebClient().geturl()}register"),
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode != 201) {
      return false;
    }

    return true;
  }

  Future<bool> login(String email, String password) async {
    http.Response response = await client.post(
      Uri.parse("${WebClient().geturl()}login"),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.body == '"Email format is invalid"') {
      throw FormatEmailException();
    }

    if(response.body == '"Incorrect password"'){
      throw IncorrectPasswordException();
    }

    if (response.body == "jwt expired") {
      throw InvalidTokenException();
    }

    if (response.statusCode != 200) {
      return false;
    }

    Map<String, dynamic> jsonResponse = json.decode(response.body);

    getInstanceSharedPreferences().then((prefs) {
      prefs.setString('email', jsonResponse["user"]['email']);
      prefs.setString('password', password);
      prefs.setString("token", jsonResponse['accessToken']);
      prefs.setInt('userId', jsonResponse["user"]['id']);
    });
    return true;
  }
}

class InvalidTokenException implements Exception {}

class FormatEmailException implements Exception {}

class IncorrectPasswordException implements Exception{}
