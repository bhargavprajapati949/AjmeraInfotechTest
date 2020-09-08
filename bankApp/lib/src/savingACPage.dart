import 'package:bankApp/src/databaseHelper.dart';
import 'package:bankApp/src/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class SavingACPage extends StatefulWidget {
  @override
  _SavingACPageState createState() => _SavingACPageState();
}

class _SavingACPageState extends State<SavingACPage> {
  TextEditingController dabitController = new TextEditingController();
  TextEditingController creditController = new TextEditingController();

  String warnningMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saving AC"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              child: Container(
                child: Consumer<DatabaseHelper>(
                  builder: (context, value, child) {
                    return FutureBuilder<int>(
                      future: value.getSavingBal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(snapshot.data.toString());
                        }
                        return Text("0");
                      },
                    );
                  },
                ),
              ),
              height: 200,
            ),
            Consumer<DatabaseHelper>(
              builder: (context, value, child) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: value.getSavingTransaction(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var trans = snapshot.data;
                      return SizedBox(
                        height: 500,
                        child: ListView(
                          children: trans == null
                              ? [
                                  Container(),
                                ]
                              : trans.map((item) {
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
                                }).toList(),
                        ),
                      );
                    } else {
                      return Container();
                    }
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
                        // return AlertDialog(
                        //   title: Text("Debit"),
                        //   content: TextField(
                        //     controller: dabitController,
                        //   ),
                        //   actions: [
                        //     RaisedButton(
                        //       child: Text("Debit"),
                        //       onPressed: () {},
                        //     ),
                        //     RaisedButton(
                        //       child: Text("Cancal"),
                        //       onPressed: () {
                        //         Navigator.pop(context);
                        //       },
                        //     ),
                        //   ],
                        // );
                        return AlertDialog(
                          title: Text("Debit"),
                          content: Column(
                            children: [
                              TextField(
                                controller: dabitController,
                              ),
                              Text(warnningMsg ?? ""),
                            ],
                          ),
                          actions: [
                            RaisedButton(
                              child: Text("Debit"),
                              onPressed: () {
                                if (int.parse(creditController.text) % 500 ==
                                    0) {
                                  int result = Provider.of<DatabaseHelper>(
                                          context,
                                          listen: false)
                                      .debitSavingAmount(
                                          int.parse(creditController.text));
                                  if (result == -1) {
                                    setState(() {
                                      this.warnningMsg = "faild";
                                    });
                                  } else {
                                    Navigator.pop(context);
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
                              child: Text("Cancle"),
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
                          title: Text("Credit"),
                          content: Column(
                            children: [
                              TextField(
                                controller: creditController,
                              ),
                              Text(warnningMsg ?? " "),
                            ],
                          ),
                          actions: [
                            RaisedButton(
                              child: Text("Credit"),
                              onPressed: () async {
                                if (int.parse(creditController.text) % 500 ==
                                    0) {
                                  print("pass");
                                  int result =
                                      await Provider.of<DatabaseHelper>(context,
                                              listen: false)
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
            )
          ],
        ),
      ),
    );
  }
}
