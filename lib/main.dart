import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes/screens/notes.dart';

void main() {


  runApp(
    MaterialApp(
        title: 'Мои заметки',
        initialRoute: '/',
        routes: {
          '/': (context) => Notes(),
//          '/contacts': (context) => ContactListPage(),
        },
        theme: new ThemeData(
          // Add the 3 lines from here...
          primaryColor: Colors.black,
        ),
        // ... to here.
        debugShowCheckedModeBanner: false
    ),
  );
}
