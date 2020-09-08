import 'package:bankApp/src/databaseHelper.dart';
import 'package:bankApp/src/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavingACPage extends StatefulWidget {
  @override
  _SavingACPageState createState() => _SavingACPageState();
}

class _SavingACPageState extends State<SavingACPage> {
  TextEditingController debitController = new TextEditingController();
  TextEditingController creditController = new TextEditingController();

  String warnningMsg = "";

  void setWarnning(String msg) {
    setState(() {
      this.warnningMsg = msg;
    });

    Future.delayed(
      Duration(seconds: 2),
      () => {
        this.setState(() {
          this.warnningMsg = "";
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saving AC"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Container(
                  child: Consumer<DatabaseHelper>(
                    builder: (context, value, child) {
                      return FutureBuilder<int>(
                        future: value.getSavingBal(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                                "Balance : " + snapshot.data.toString());
                          }
                          return Text("0");
                        },
                      );
                    },
                  ),
                ),
                height: 100,
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
                                    print(item);
                                    return Card(
                                      child: ListTile(
                                        leading: Text(TransactionType.values[
                                                    item[
                                                        transactionTypeName]] ==
                                                TransactionType.Credit
                                            ? "Cradit"
                                            : "Debit"),
                                        title:
                                            Text(item[amountName].toString()),
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
              Text(warnningMsg),
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
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: debitController,
                                ),
                                Text(warnningMsg),
                              ],
                            ),
                            actions: [
                              RaisedButton(
                                child: Text("Debit"),
                                onPressed: () async {
                                  if (int.parse(debitController.text) % 500 ==
                                      0) {
                                    int result = await Provider.of<
                                                DatabaseHelper>(context,
                                            listen: false)
                                        .debitSavingAmount(
                                            int.parse(debitController.text));
                                    if (result == -1) {
                                      setWarnning("Failed");
                                    }
                                  } else {
                                    setWarnning(
                                        "Amount should multiple of 500");
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              RaisedButton(
                                child: Text("Cancel"),
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
                              mainAxisSize: MainAxisSize.min,
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
                                onPressed: () async {
                                  if (int.parse(creditController.text) % 500 ==
                                      0) {
                                    int result = await Provider.of<
                                                DatabaseHelper>(context,
                                            listen: false)
                                        .addSavingAmount(
                                            int.parse(creditController.text));
                                    if (result == -1) {
                                      setWarnning("Failed");
                                    }
                                  } else {
                                    setWarnning(
                                        "Amount should multiple of 500");
                                  }
                                  Navigator.pop(context);
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
      ),
    );
  }
}
