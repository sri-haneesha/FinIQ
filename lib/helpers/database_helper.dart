import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart' as txn;
import '../models/investment.dart' as inv;

// database table and column names
final String tableTransactions = 'transactions';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnAmount = 'amount';
final String columnCategory = 'category';
final String columnDate = 'date';

final String tableIncomes = 'incomes';
final String tableGoals = 'goals';
final String tableInvestments = 'investments';

// singleton class to manage the database
class DatabaseHelper {
  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // actual database filename that is saved in the docs directory
  static final _databaseName = "app_database.db";
  static final _databaseVersion = 10;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Upgrade database
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableInvestments (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }

  // Create tables: Transactions, Incomes, Goals, Investments, and Users
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTransactions (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableIncomes (
        $columnId INTEGER PRIMARY KEY,
        $columnAmount REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableGoals (
        $columnId INTEGER PRIMARY KEY,
        $columnAmount REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableInvestments (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  // User-related functions
  Future<int> registerUser(String username, String password) async {
    Database? db = await instance.database;
    return await db!
        .insert('users', {'username': username, 'password': password});
  }

  Future<bool> verifyUser(String username, String password) async {
    Database? db = await instance.database;
    final result = await db!.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  // Transaction-related functions
  Future<int> insert(txn.Transaction element) async {
    Database? db = await database;
    int id = await db?.insert(tableTransactions, element.toMap()) ?? 0;
    return id;
  }

  Future<txn.Transaction?> getTransactionById(int id) async {
    Database? db = await database;
    if (db != null) {
      List<Map<String, dynamic>> res = await db.query(
        tableTransactions,
        columns: [
          columnId,
          columnTitle,
          columnAmount,
          columnCategory,
          columnDate
        ],
        where: '$columnId = ?',
        whereArgs: [id],
      );

      if (res.isNotEmpty) {
        return txn.Transaction.fromMap(res.first);
      }
    }
    return null;
  }

  Future<List<txn.Transaction>> getAllTransactions() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = [];

    if (db != null) {
      res = await db.query(tableTransactions, columns: [
        columnId,
        columnTitle,
        columnAmount,
        columnCategory,
        columnDate
      ]);
    }

    List<txn.Transaction> list =
        res.map((e) => txn.Transaction.fromMap(e)).toList();
    return list;
  }

  Future<double> calculateTotalExpenseAmount() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = [];

    if (db != null) {
      res = await db.query(tableTransactions, columns: [
        columnId,
        columnTitle,
        columnAmount,
        columnCategory,
        columnDate
      ]);
    }

    List<txn.Transaction> list =
        res.map((e) => txn.Transaction.fromMap(e)).toList();
    // Calculate the sum of columnAmount
    double sum = list.fold(0,
        (previousValue, transaction) => previousValue + transaction.txnAmount);
    return sum;
  }

  Future<int> deleteTransactionById(int id) async {
    Database? db = await database;
    if (db != null) {
      int res = await db.delete(
        tableTransactions,
        where: "id = ?",
        whereArgs: [id],
      );
      return res;
    } else {
      return 0;
    }
  }

  Future<int> deleteAllTransactions() async {
    Database? db = await database;
    if (db != null) {
      int res = await db.delete(tableTransactions, where: '1');
      return res;
    } else {
      return 0;
    }
  }

  // Income-related functions
  Future<int> insertIncome(double amount) async {
    final db = await database;
    return await db!.insert(tableIncomes, {'$columnAmount': amount});
  }

  Future<double?> getIncome() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db!.query(tableIncomes);
    if (result.isNotEmpty) {
      return result.first[columnAmount] as double;
    } else {
      return null;
    }
  }

  Future<void> updateIncome(double amount) async {
    final db = await database;
    await db!.update(tableIncomes, {'$columnAmount': amount});
  }

  // Goal-related functions
  Future<int> insertGoal(double amount) async {
    final db = await database;
    return await db!.insert(tableGoals, {'$columnAmount': amount});
  }

  Future<double?> getGoal() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db!.query(tableGoals);
    if (result.isNotEmpty) {
      return result.first[columnAmount] as double;
    } else {
      return null;
    }
  }

  Future<void> updateGoal(double amount) async {
    final db = await database;
    await db!.update(tableGoals, {'$columnAmount': amount});
  }

  // Investment-related functions
  Future<int> insertInvestment(inv.Investment element) async {
    Database? db = await database;
    int id = await db?.insert(tableInvestments, element.toMap()) ?? 0;
    return id;
  }

  Future<inv.Investment?> getInvestmentById(int id) async {
    Database? db = await database;
    if (db != null) {
      List<Map<String, dynamic>> res = await db.query(
        tableInvestments,
        columns: [columnId, columnTitle, columnAmount, columnDate],
        where: '$columnId = ?',
        whereArgs: [id],
      );

      if (res.isNotEmpty) {
        return inv.Investment.fromMap(res.first);
      }
    }
    return null;
  }

  Future<List<inv.Investment>> getAllInvestments() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = [];

    if (db != null) {
      res = await db.query(tableInvestments,
          columns: [columnId, columnTitle, columnAmount, columnDate]);
    }

    List<inv.Investment> list =
        res.map((e) => inv.Investment.fromMap(e)).toList();
    return list;
  }

  Future<double> calculateTotalInvestmentAmount() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = [];

    if (db != null) {
      res = await db.query(tableInvestments,
          columns: [columnId, columnTitle, columnAmount, columnDate]);
    }

    List<inv.Investment> list =
        res.map((e) => inv.Investment.fromMap(e)).toList();
    double sum = list.fold(
        0, (previousValue, investment) => previousValue + investment.invAmount);
    return sum;
  }

  Future<int> deleteInvestmentById(int id) async {
    Database? db = await database;
    if (db != null) {
      int res = await db.delete(
        tableInvestments,
        where: "id = ?",
        whereArgs: [id],
      );
      return res;
    } else {
      return 0;
    }
  }

  Future<int> deleteAllInvestments() async {
    Database? db = await database;
    if (db != null) {
      int res = await db.delete(tableInvestments, where: '1');
      return res;
    } else {
      return 0;
    }
  }
}
