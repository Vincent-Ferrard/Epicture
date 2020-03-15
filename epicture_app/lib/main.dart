import 'package:flutter/material.dart';

import 'Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {

  bool login = false;

  @override
  Widget build(BuildContext context) {
    StatefulWidget window;

    if (login == false) {
      window = Scaffold(
        appBar: AppBar(
          title: Text("Epicture"),
        ),
        body: Center(
          child: RaisedButton(
            child: Text("Login"),
            onPressed: () {
              setState(() {
                login = true;
              });
            },
          ),
        ),
      );
    } else {
      window = Login();
      setState(() {login = false;});
    }

    return MaterialApp(
      title: 'Epicture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: window,
    );
  }
}