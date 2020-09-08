import 'package:bankApp/src/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:bankApp/src/homepage.dart';
import 'package:bankApp/src/savingACPage.dart';
import 'package:bankApp/src/checkingACPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DatabaseHelper>(
      create: (context) => DatabaseHelper(),
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => HomePage(),
          "checkingACPage": (BuildContext context) => CheckingACPage(),
          "savingACPage": (BuildContext context) => SavingACPage(),
        },
      ),
    );
  }
}
