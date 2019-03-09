import 'dart:io';
import 'package:notes/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DB{

  String tblNotes = "Notes";
  String colID = "ID";
  String colText = "Text";
  String colDate = "Date";

  static final DB _dbHelper = DB._internal();
  DB._internal();

  factory DB(){
    return _dbHelper;
  }

  static Database _db;
  Future<Database> get db async{
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "Notes.db";
    var dbList = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbList;
  }

  void _createDb(Database db, int version) async{
    await db.execute("Create Table $tblNotes($colID integer primary key, $colText text, $colDate text)");
  }

  Future<int> insert(NoteModel note) async{
    Database db = await this.db;
    var result = await db.insert(tblNotes, note.toMap());
    return result;
  }

  Future<int> update(NoteModel note) async{
    Database db = await this.db;
    var result = await db.update(tblNotes, note.toMap(), where: "$colID = ?", whereArgs: [note.id]);
    return result;
  }

  Future<int> delete(int id) async{
    Database db = await this.db;
    var result = await db.rawDelete("Delete From $tblNotes where $colID = $id");
    return result;
  }

  Future<List> getNotes() async{
    Database db = await this.db;
    var result = await db.rawQuery("Select * From $tblNotes");
    return result;
  }

  Future<int> deleteAllNotes() async{
    Database db = await this.db;
    var result = await db.rawDelete("Delete From $tblNotes");
    return result;
  }
}