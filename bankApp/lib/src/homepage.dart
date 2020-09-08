import 'package:bankApp/src/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bank App"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Consumer<DatabaseHelper>(
                    builder: (context, value, child) {
                      return FutureBuilder<String>(
                        future: value.getName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            print(snapshot.data);
                            return Text(snapshot.data ?? "");
                          }
                          return Container();
                        },
                      );
                    },
                  ),
                ],
              ),
              height: 200,
            ),
            Container(
              child: RaisedButton(
                child: Text("Saving AC"),
                onPressed: () {
                  Navigator.pushNamed(context, "savingACPage");
                },
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text("Checking AC"),
                onPressed: () {
                  Navigator.pushNamed(context, "checkingACPage");
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
