import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider {
  Database db;

  void init() async {
    // getApplicationDocumentsDirectory provided by path_provider
    // type Directory is from dart:io
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // reference to the actual database
    final path = join(documentsDirectory.path, 'items.db');
    // openDatabase is provided by sqlite
    // it will either open a current database or if there isn't one it
    // will create a new database
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        // only called the first time the user starts up our app
        newDb.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY,
            deleted INTEGER,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            dead INTEGER,
            parent INTEGER,
            kids BLOB,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        ''');
      }
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      'items',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) return ItemModel.fromDb(maps.first);

    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert('items', item.toMapForDb());
  }
}