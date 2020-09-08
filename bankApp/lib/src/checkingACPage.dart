import 'package:bankApp/src/databaseHelper.dart';
import 'package:bankApp/src/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckingACPage extends StatefulWidget {
  @override
  _CheckingACPageState createState() => _CheckingACPageState();
}

class _CheckingACPageState extends State<CheckingACPage> {
  TextEditingController dabitController = new TextEditingController();
  TextEditingController creditController = new TextEditingController();

  String warnningMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checking AC"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              child: Container(
                child: Consumer<DatabaseHelper>(
                  builder: (context, value, child) {
                    return FutureBuilder(
                      future: value.getCheckingBal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(snapshot.data);
                        }
                        return null;
                      },
                    );
                  },
                ),
              ),
              height: 200,
            ),
            Consumer<DatabaseHelper>(
              builder: (context, value, child) {
                return FutureBuilder(
                  future: value.getCheckingTransaction(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var trans = snapshot.data;
                      return ListView(
                        children: [
                          trans.map((item) {
                            return Card(
                              child: ListTile(
                                leading: Text(item[transactionTypeName]),
                                title: Text(item[amountName]),
                                trailing: Text(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            item[timeStamp])
                                        .toString()),
                              ),
                            );
                          }),
                        ],
                      );
                    }
                    return null;
                  },
                );
              },
            ),
            Row(
              children: [
                RaisedButton(
                  child: Text("Debit"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Debit"),
                          content: TextField(
                            controller: dabitController,
                          ),
                          actions: [
                            RaisedButton(
                              child: Text("Debit"),
                              onPressed: () {},
                            ),
                            RaisedButton(
                              child: Text("Cancal"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                RaisedButton(
                  child: Text("Credit"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Debit"),
                          content: Column(
                            children: [
                              TextField(
                                controller: creditController,
                              ),
                              Text(warnningMsg),
                            ],
                          ),
                          actions: [
                            RaisedButton(
                              child: Text("Credit"),
                              onPressed: () {
                                if (int.parse(creditController.text) % 500 ==
                                    0) {
                                  int result =
                                      Provider.of<DatabaseHelper>(context)
                                          .addSavingAmount(
                                              int.parse(creditController.text));
                                  if (result == -1) {
                                    setState(() {
                                      this.warnningMsg = "faild";
                                    });
                                  }
                                } else {
                                  setState(() {
                                    this.warnningMsg =
                                        "Amount should multiple of 500";
                                  });
                                }
                              },
                            ),
                            RaisedButton(
                              child: Text("Calcal"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
