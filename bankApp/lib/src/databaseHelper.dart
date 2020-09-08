import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:bankApp/package/sqflite/sqflite/lib/sqflite.dart';
// import 'package:bankApp/package/sqflite/sqflite/lib/sqlite_api.dart';

import 'package:bankApp/src/variables.dart';

class DatabaseHelper extends ChangeNotifier {
  final int _databaseVersion = 1;

  // make this a singleton class
  // DatabaseHelper._privateConstructor();
  // static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database _database;
  Future<Database> get database async {
    if (this._database != null) {
      return this._database;
    }
    // lazily instantiate the db the first time it is accessed
    this._database = await _initDatabase();
    return this._database;
  }

  DatabaseHelper() {
    initializeDB();
  }

  void initializeDB() async {
    if (this._database == null) {
      this._database = await _initDatabase();
    }
    Database database = await this.database;

    database.insert(personalInfoTableName, {
      nameName: "Bhargav",
      checkingACbalName: 10000,
      savingACbalName: 10000,
    });
    notifyListeners();
  }

  _initDatabase() async {
    // String appFolder = Directory('')
    String databaseDirectory = await getDatabasesPath();
    String path = join(databaseDirectory, "BankAppDatabase");

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $personalInfoTableName (
        $nameName TEXT,
        $savingACbalName INTEGER ,
        $checkingACbalName INTEGER
      );
      ''');

    await db.execute('''
      CREATE TABLE $savingAcTransactionTableName (
        $timeStamp INTEGER,
        $transactionTypeName INTEGER,
        $amountName INTEGER
      );
      ''');

    await db.execute('''
      CREATE TABLE $checkingAcTransactionTableName (
        $timeStamp INTEGER,
        $transactionTypeName INTEGER,
        $amountName INTEGER
      );
      ''');
  }

  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<String> getName() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.rawQuery("select $nameName from $personalInfoTableName;");
    return result[0][nameName];
  }

  Future<int> getSavingBal() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db
        .rawQuery("select $savingACbalName from $personalInfoTableName;");
    return result[0][savingACbalName];
  }

  Future<int> setSavingBal(int newBal) async {
    Database db = await database;
    int result = await db.rawUpdate(
        "Update $personalInfoTableName SET $savingACbalName = ?;", [newBal]);
    notifyListeners();
    return result;
  }

  Future<int> getCheckingBal() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db
        .rawQuery("select $checkingACbalName from $personalInfoTableName;");
    return result[0][checkingACbalName];
  }

  Future<int> setCheckingBal(int newBal) async {
    Database db = await database;
    int result = await db.rawUpdate(
        "Update $personalInfoTableName SET $checkingACbalName = ?;", [newBal]);
    notifyListeners();
    return result;
  }

  Future<List<Map<String, dynamic>>> getSavingTransaction() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.rawQuery("select * from $savingAcTransactionTableName;");
    return result;
  }

  Future<List<Map<String, dynamic>>> getCheckingTransaction() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.rawQuery("select * from $checkingAcTransactionTableName;");
    return result;
  }

  Future<int> addSavingAmount(int amount) async {
    Database db = await database;
    int index = await db.insert(savingAcTransactionTableName, {
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      transactionTypeName: TransactionType.Credit,
      amountName: amount,
    });
    int newSavingBal = await this.getSavingBal() + amount;
    setSavingBal(newSavingBal);
    notifyListeners();
    return index;
  }

  Future<int> addCheckingAmount(int amount) async {
    Database db = await database;
    int index = await db.insert(checkingAcTransactionTableName, {
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      transactionTypeName: TransactionType.Credit,
      amountName: amount,
    });
    int newCheckingBal = await this.getCheckingBal() + amount;
    setSavingBal(newCheckingBal);
    notifyListeners();
    return index;
  }

  Future<int> debitSavingAmount(int amount) async {
    Database db = await database;
    int newSavingBal = await this.getSavingBal() - amount;
    if (newSavingBal <= 0) {
      return -1;
    }
    int index = await db.insert(savingAcTransactionTableName, {
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      transactionTypeName: TransactionType.Debit,
      amountName: amount,
    });
    setSavingBal(newSavingBal);
    notifyListeners();
    return index;
  }

  Future<int> debitCheckingAmount(int amount) async {
    Database db = await database;
    int newChackingBal = await this.getCheckingBal() - amount;
    if (newChackingBal <= 0) {
      return -1;
    }
    int index = await db.insert(checkingAcTransactionTableName, {
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      transactionTypeName: TransactionType.Debit,
      amountName: amount,
    });
    setCheckingBal(newChackingBal);
    notifyListeners();
    return index;
  }
}
