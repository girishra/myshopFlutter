import 'package:my_shop/config/AppConfig.dart';
import 'package:flutter/material.dart';


class HttpExceptionDialog {

  void showAlertDialog(context, message) {
    print('Dalog Called');
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert", style: TextStyle(color: Colors.blue),),
          content: new Text(AppConfig.httpStatusCodeRec.toString() +" "+  message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
}