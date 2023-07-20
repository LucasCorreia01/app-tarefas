import 'package:flutter/material.dart';

showConfirmationDialog({
  String title = 'Atenção',
  String content = 'Tem certeza que deseja confirmar sua escolha?',
  String affirmationChoice = 'Confirmar',
  String negattiveChoice = 'Cancelar',
  required BuildContext context,
}) async{
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(affirmationChoice,),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);

              },
              child: Text(negattiveChoice),
            ),
          ],
        );
      });
}
