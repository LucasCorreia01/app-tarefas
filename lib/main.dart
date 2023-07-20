import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/screens/add_task_screen.dart';
import 'package:tarefas/screens/initial_screen.dart';
import 'package:tarefas/screens/login_screen.dart';
import 'package:tarefas/services/auth_service.dart';
import 'package:tarefas/services/task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLogged = await verifyToken();
  runApp(MainApp(isLogged));
}

Future<bool> verifyToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if(token != null){
      return true;
    }
    return false;
}

// ignore: must_be_immutable
class MainApp extends StatelessWidget {
  bool isLogged;
  MainApp(this.isLogged, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
        ),
      ),
      initialRoute: (isLogged) ? "home" : "login",
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == 'home') {
          return MaterialPageRoute(
            builder: (context) {
              return const InitialScreen();
            },
          );
        } else if (settings.name == 'add-task') {
          return MaterialPageRoute(
            builder: (context) {
              return AddTaskScreen(
                context: settings.arguments,
              );
            },
          );
        } else if (settings.name == 'edit-task') {
          return MaterialPageRoute(builder: (context) {
            Map<String, dynamic> map =
                settings.arguments as Map<String, dynamic>;
            return AddTaskScreen(
              context: map['context'],
              idTask: map['idTask'],
              nameTask: map['nameTask'],
              imageUrl: map['imageUrl'],
              difficulty: map['difficulty'],
              isEditing: true,
            );
          });
        } else if (settings.name == "login") {
          return MaterialPageRoute(builder: (context) {
            return const LoginScreen();
          });
        } else {
          return MaterialPageRoute(builder: (context) {
            return const LoginScreen();
          });
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
