import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as pth;
import 'package:sqflite/sqflite.dart';

/// This is file that have all functionality to interact with database
class DBHelper {
  static Future<Database> database() async {
    //First we need to create table
    final dbPath = await sql.getDatabasesPath();
    // We're opening database now and giving the name for the database
    // in our case will be 'places.db'
    return sql.openDatabase(pth.join(dbPath, 'places.db'), version: 1,
        //onCrate will fire up only if we don't have database
        // in that case it will create database, otherwise it will only
        //open database
        onCreate: (db, version) async {
      //We're using sql commands here
      //TEXT PRIMARY KEY means it's of a type text and that primary key
      // we'll use is gonna be "id" and not title or image or something else
//this means that we'll create table "user_places"
      // NOTE!!! Image is text for a path to the image storage
      // REAL is like double but for SQL
      return db.execute(
          'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    });
  }

  /// This is generic function where we can choose which table we're gonna
  /// select and object we're passing is Map
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    //this command insert data in database
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    //this command retrieve data from database
    return db.query(table);
  }
}
