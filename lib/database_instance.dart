import 'dart:convert';
import 'dart:io';
import 'package:customer_app/model/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstance {
  final String databaseName = "my_database.db";
  final int databaseVersion = 1;

  final String table = "product";
  final String id = "id";
  final String nameProduct = "name_product";
  final String price = "price";
  final String qty = "qty";
  final String totalPrice = "total_price";

  Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return openDatabase(path, version: databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table ($id TEXT PRIMARY KEY, $nameProduct TEXT NULL , $price TEXT NULL,$qty TEXT NULL,$totalPrice TEXT NULL)');
  }

  Future<List<ProductModel>> all() async {
    final data = await _database!.query(table);
    List<ProductModel> result =
        data.map((e) => ProductModel.fromJson(e)).toList();
    return result;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final query = await _database!.insert(table, row);
    return query;
  }

  Future<int> update(String idParam, Map<String, dynamic> row) async {
    final query = await _database!
        .update(table, row, where: '$id = ?', whereArgs: [idParam]);
    return query;
  }

  Future delete(String idParam) async {
    await _database!.delete(table, where: '$id = ?', whereArgs: [idParam]);
  }
}
