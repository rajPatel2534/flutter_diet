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
  String mineralItemItemUnitId = 'item_unit_id';
  String mineralItemMineralUnitId = 'mineral_unit_id';
  String mineralItemMineralId = 'mineral_id';
  String mineralItemItemId = 'item_id';
  String mineralItemMineralQuantity = 'mineral_quantity';
  String mineralItemItemQuantity = 'item_quantity';

 MineralItemDatabaseHelper._createInstance();

factory MineralItemDatabaseHelper(){
    //For singleton obj
    if(_mineralItemDatabaseHelper == null){
    _mineralItemDatabaseHelper = MineralItemDatabaseHelper._createInstance();
    }
    return _mineralItemDatabaseHelper;
  } 



  Future<List<Map<String, dynamic>>> getMineralItemListMap(int itemId) async{
    Database db = await _databaseHelper.database;
    var result = await db.rawQuery("SELECT * FROM $mineralItemTable WHERE $mineralItemItemId == $itemId ORDER BY $mineralItemId");
    return result;
  }

  Future<int> insertMineralItem(MineralItem mineralItem) async{
      Database db = await _databaseHelper.database;
      var result = await db.insert(mineralItemTable, mineralItem.toMap());
      return result;
  }

  Future<int> updateMineralItem(MineralItem mineralItem) async{
      Database db = await _databaseHelper.database;
      var result = await db.update(mineralItemTable, mineralItem.toMap(),where: '$mineralItemId = ?', whereArgs: [mineralItem.id]);
      return result;
  }

    Future<int> deleteMineralItem(int id) async{
      Database db = await _databaseHelper.database;
      var result = await db.rawDelete('DELETE FROM $mineralItemTable WHERE $mineralItemId = $id');
      return result;
  }

  Future<int> getCount(int id) async{
      Database db = await _databaseHelper.database;;
      List<Map<String, dynamic>> mineralItems = await db.rawQuery("SELECT COUNT (*) FROM $mineralItemTable");
      int mineralItemsLength = Sqflite.firstIntValue(mineralItems);
      return mineralItemsLength;
  }

  Future<List<MineralItem>> getMineralItemList(int itemId) async{
    var mineralItemMapList = await getMineralItemListMap(itemId);
    int count = mineralItemMapList.length;
    List<MineralItem> mineralItemList = List<MineralItem>();

    for(int i=0;i< count ;i++){
      mineralItemList.add(MineralItem.fromMapObject(mineralItemMapList[i]));
    }
    
    return mineralItemList;
  }

  Future<List<MineralItemWithObj>> getMineralItemListWithObj(int itemId) async{
    List<MineralItem> listOfMineralItem = await getMineralItemList(itemId);  
    List<MineralItemWithObj> listOfMineralItemWithObj = List<MineralItemWithObj>();
    for(int i=0;i<listOfMineralItem.length ; i++){
          listOfMineralItemWithObj.add(MineralItemWithObj.withId(
            listOfMineralItem[i].id,
            await mineralItemDatabaseHelper.getMineral(listOfMineralItem[i].mineralId),
            await itemDatabaseHelper.getItem(listOfMineralItem[i].itemId),
            listOfMineralItem[i].itemQuantity,
            await unitDatabaseHelper.getUnit(listOfMineralItem[i].itemUnitId),
            listOfMineralItem[i].mineralQuantity,
            await unitDatabaseHelper.getUnit(listOfMineralItem[i].mineralUnitId)

          ));
    }
    return listOfMineralItemWithObj;
  }

  saveMineralItemObj(MineralItemWithObj mineralItemWithObj){
    if(mineralItemWithObj != null){
        updateMineralItem(MineralItem.withId(mineralItemWithObj.id,mineralItemWithObj.mineral.id,mineralItemWithObj.item.id,
        mineralItemWithObj.itemQuantity,mineralItemWithObj.itemUnit.id,mineralItemWithObj.mineralQuantity,mineralItemWithObj.mineralUnit.id));
    }
    else{
       insertMineralItem(MineralItem(mineralItemWithObj.mineral.id,mineralItemWithObj.item.id,
       mineralItemWithObj.itemQuantity,mineralItemWithObj.itemUnit.id,mineralItemWithObj.mineralQuantity,mineralItemWithObj.mineralUnit.id));
    }
  }
  saveMineralItemObjList(List<MineralItemWithObj> mineralItemWithObj){

    for(int i=0;i<mineralItemWithObj.length ; i++)
    {
      if(mineralItemWithObj[i].id != null){
      updateMineralItem(MineralItem.withId(mineralItemWithObj[i].id,mineralItemWithObj[i].mineral.id,mineralItemWithObj[i].item.id,
        mineralItemWithObj[i].itemQuantity,mineralItemWithObj[i].itemUnit.id,mineralItemWithObj[i].mineralQuantity,mineralItemWithObj[i].mineralUnit.id));  
      } 
      else{
      insertMineralItem(MineralItem(mineralItemWithObj[i].mineral.id,mineralItemWithObj[i].item.id,
        mineralItemWithObj[i].itemQuantity,mineralItemWithObj[i].itemUnit.id,mineralItemWithObj[i].mineralQuantity,mineralItemWithObj[i].mineralUnit.id));
      }
    }
  }
  
}