import 'package:flutter/widgets.dart';
import 'package:login_demo/models/item.dart';
import 'package:login_demo/models/mineral_item.dart';
import 'package:login_demo/models_with_obj/mineral_item_dto.dart';
import 'package:login_demo/utils/database_helper.dart';
import 'package:login_demo/utils/item_database_helper.dart';
import 'package:login_demo/utils/mineral_database_helper.dart';
import 'package:login_demo/utils/unit_database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class MineralItemDatabaseHelper{
  static MineralItemDatabaseHelper _mineralItemDatabaseHelper;
  ItemDatabaseHelper itemDatabaseHelper = ItemDatabaseHelper();
  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();
  MineralDatabaseHelper mineralItemDatabaseHelper = MineralDatabaseHelper();
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String mineralItemTable = 'mineral_item';
  String mineralItemId = 'mineral_item_id';
  String mineralItemUnitId = 'unit_id';
  String mineralItemMineralId = 'mineral_id';
  String mineralItemItemId = 'item_id';
  String mineralItemMineralQuantity = 'quantity';

 MineralItemDatabaseHelper._createInstance();

factory MineralItemDatabaseHelper(){
    //For singleton obj
    if(_mineralItemDatabaseHelper == null){
    _mineralItemDatabaseHelper = MineralItemDatabaseHelper._createInstance();
    }
    return _mineralItemDatabaseHelper;
  } 



  Future<List<Map<String, dynamic>>> getNoteListMap(int itemId) async{
    Database db = await _databaseHelper.database;
    var result = await db.rawQuery("SELECT * FROM $mineralItemTable WHERE $mineralItemItemId == $itemId ORDER BY $mineralItemId");
    return result;
  }

  Future<int> insertNote(MineralItem note) async{
      Database db = await _databaseHelper.database;
      var result = await db.insert(mineralItemTable, note.toMap());
      return result;
  }

  Future<int> updateNote(MineralItem note) async{
      Database db = await _databaseHelper.database;
      debugPrint('${note.toMap()}');
      var result = await db.update(mineralItemTable, note.toMap(),where: '$mineralItemId = ?', whereArgs: [note.id]);
      debugPrint('$result');
      return result;
  }

    Future<int> deleteNote(int id) async{
      Database db = await _databaseHelper.database;
      var result = await db.rawDelete('DELETE FROM $mineralItemTable WHERE $mineralItemId = $id');
      return result;
  }

  Future<int> getCount(int id) async{
      Database db = await _databaseHelper.database;;
      List<Map<String, dynamic>> notes = await db.rawQuery("SELECT COUNT (*) FROM $mineralItemTable");
      int notesLength = Sqflite.firstIntValue(notes);
      return notesLength;
  }

  Future<List<MineralItem>> getNoteList(int itemId) async{
    var noteMapList = await getNoteListMap(itemId);
    int count = noteMapList.length;
    List<MineralItem> noteList = List<MineralItem>();

    for(int i=0;i< count ;i++){
      noteList.add(MineralItem.fromMapObject(noteMapList[i]));
    }
    
    return noteList;
  }

  Future<List<MineralItemWithObj>> getMineralItemListWithObj(int itemId) async{
    List<MineralItem> listOfMineralItem = await getNoteList(itemId);  
    List<MineralItemWithObj> listOfMineralItemWithObj = List<MineralItemWithObj>();
    for(int i=0;i<listOfMineralItem.length ; i++){
          listOfMineralItemWithObj.add(MineralItemWithObj.withId(
            listOfMineralItem[i].id,
            await mineralItemDatabaseHelper.getMineral(listOfMineralItem[i].mineralId),
            await itemDatabaseHelper.getItem(listOfMineralItem[i].itemId),
            listOfMineralItem[i].quantity,
            await unitDatabaseHelper.getUnit(listOfMineralItem[i].unitId)

          ));
    }
    return listOfMineralItemWithObj;
  }

  saveMineralItemObj(MineralItemWithObj mineralItemWithObj){
    if(mineralItemWithObj != null){
        updateNote(MineralItem.withId(mineralItemWithObj.id,mineralItemWithObj.mineral.id,mineralItemWithObj.item.id,
        mineralItemWithObj.quantity,mineralItemWithObj.unit.id));
    }
    else{
       insertNote(MineralItem(mineralItemWithObj.mineral.id,mineralItemWithObj.item.id,
        mineralItemWithObj.quantity,mineralItemWithObj.unit.id));
    }
  }
  saveMineralItemObjList(List<MineralItemWithObj> mineralItemWithObj){

    for(int i=0;i<mineralItemWithObj.length ; i++)
    {
      if(mineralItemWithObj[i].id != null){
        debugPrint('update');
      updateNote(MineralItem.withId(mineralItemWithObj[i].id,mineralItemWithObj[i].mineral.id,mineralItemWithObj[i].item.id,
        mineralItemWithObj[i].quantity,mineralItemWithObj[i].unit.id));  
      } 
      else{
      insertNote(MineralItem(mineralItemWithObj[i].mineral.id,mineralItemWithObj[i].item.id,
        mineralItemWithObj[i].quantity,mineralItemWithObj[i].unit.id));
      }
    }
  }
  
}