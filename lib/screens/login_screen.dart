import 'package:flutter/material.dart';
import 'package:tarefas/common/confirmation_dialog.dart';
import 'package:tarefas/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(); //controlador do input de email
  final TextEditingController _passwordController =
      TextEditingController(); //controlador do input de senha
  final _formKey = GlobalKey<FormState>(); // key do form

  AuthService authService = AuthService(); // serviço de autenticação
  bool _passwordVisible = true; // input de senha

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fazer login'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 400,
            height: 400,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Insira seus dados:',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value != null && value != "") {
                          return null;
                        }
                        return 'Insira um e-mail válido!';
                      },
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Email"),
                      style: const TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value != null && value != "") {
                          return null;
                        }
                        return "Insira sua senha";
                      },
                      controller: _passwordController,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return Colors.white;
                        }),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authService
                              .login(_emailController.text,
                                  _passwordController.text)
                              .then((value) {
                            if (value) {
                              Navigator.pushReplacementNamed(context, 'home');
                            } else {
                              showConfirmationDialog(
                                context: context,
                                content:
                                    "Nenhuma conta foi encotrada com esses dados.\nDeseja se registrar utilizando o email: ${_emailController.text}",
                              ).then((value) {
                                if (value) {
                                  authService
                                      .register(
                                    _emailController.text,
                                    _passwordController.text,
                                  )
                                      .then((value) {
                                    if (value) {
                                      Navigator.pushReplacementNamed(
                                          context, 'home');
                                    }
                                  });
                                }
                              });
                            }
                          }).onError(
                            (error, stackTrace) {
                              showConfirmationDialog(
                                context: context,
                                content: 'O formato de e-mail não é válido.',
                                negattiveChoice: 'Ok',
                                affirmationChoice: ""
                              );
                            },
                            test: (error) => error is FormatEmailException,
                          ).onError((error, stackTrace) {
                            showConfirmationDialog(
                                context: context,
                                content: 'Senha incorreta.',
                                negattiveChoice: 'Ok',
                                affirmationChoice: ""
                              );
                          }, test: (error) => error is IncorrectPasswordException,);
                        }
                      },
                      child: const Text(
                        'Login',
                      ),
                    )
                  ]),
            ),
          ),
        )),
      ),
    );
  }
}
