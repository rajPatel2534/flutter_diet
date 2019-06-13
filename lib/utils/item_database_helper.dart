

import 'package:flutter/rendering.dart';
import 'package:login_demo/models/item.dart';
import 'package:login_demo/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ItemDatabaseHelper{
  static ItemDatabaseHelper _itemDatabaseHelper;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String itemTable = 'items';
  String itemId = 'item_id';
  String itemName = 'item_name';

 ItemDatabaseHelper._createInstance();

factory ItemDatabaseHelper(){
    //For singleton obj
    if(_itemDatabaseHelper == null){
    _itemDatabaseHelper = ItemDatabaseHelper._createInstance();
    }
    return _itemDatabaseHelper;
  } 



  Future<List<Map<String, dynamic>>> getNoteListMap() async{
    Database db = await _databaseHelper.database;
    var result = await db.query(itemTable,orderBy: '$itemId ASC');
    return result;
  }

  Future<int> insertNote(Item note) async{
      Database db = await _databaseHelper.database;;
      var result = await db.insert(itemTable, note.toMap());
      return result;
  }

  Future<int> updateNote(Item note) async{
      Database db = await _databaseHelper.database;;
      var result = await db.update(itemTable, note.toMap(),where: '$itemId = ?', whereArgs: [note.id]);
      return result;
  }

    Future<int> deleteNote(int id) async{
      Database db = await _databaseHelper.database;;
      var result = await db.rawDelete('DELETE FROM $itemTable WHERE $itemId = $id');
      return result;
  }

  Future<int> getCount(int id) async{
      Database db = await _databaseHelper.database;;
      List<Map<String, dynamic>> notes = await db.rawQuery("SELECT COUNT (*) FROM $itemTable");
      int notesLength = Sqflite.firstIntValue(notes);
      return notesLength;
  }

  Future<Item> getItem(int id) async{
    Database db = await _databaseHelper.database;
    List<Map<String,dynamic>> mineral = await db.rawQuery("SELECT * FROM $itemTable WHERE $itemId = $id");
   return Item.fromMapObject(mineral[0]);
  }

  Future<List<Item>> getNoteList() async{
    var noteMapList = await getNoteListMap();
    int count = noteMapList.length;
    List<Item> noteList = List<Item>();

    for(int i=0;i< count ;i++){
      noteList.add(Item.fromMapObject(noteMapList[i]));
    }
    
    return noteList;
  }
}