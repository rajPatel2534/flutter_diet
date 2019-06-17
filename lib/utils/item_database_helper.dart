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



  Future<List<Map<String, dynamic>>> getItemListMap() async{
    Database db = await _databaseHelper.database;
    var result = await db.query(itemTable,orderBy: '$itemId ASC');
    return result;
  }

  Future<int> insertItem(Item item) async{
      Database db = await _databaseHelper.database;;
      var result = await db.insert(itemTable, item.toMap());
      return result;
  }

  Future<int> updateItem(Item item) async{
      Database db = await _databaseHelper.database;;
      var result = await db.update(itemTable, item.toMap(),where: '$itemId = ?', whereArgs: [item.id]);
      return result;
  }

    Future<int> deleteItem(int id) async{
      Database db = await _databaseHelper.database;;
      var result = await db.rawDelete('DELETE FROM $itemTable WHERE $itemId = $id');
      return result;
  }

  Future<int> getCount(int id) async{
      Database db = await _databaseHelper.database;;
      List<Map<String, dynamic>> items = await db.rawQuery("SELECT COUNT (*) FROM $itemTable");
      int itemsLength = Sqflite.firstIntValue(items);
      return itemsLength;
  }

  Future<Item> getItem(int id) async{
    Database db = await _databaseHelper.database;
    List<Map<String,dynamic>> mineral = await db.rawQuery("SELECT * FROM $itemTable WHERE $itemId = $id");
   return Item.fromMapObject(mineral[0]);
  }

  Future<List<Item>> getItemList() async{
    var itemMapList = await getItemListMap();
    int count = itemMapList.length;
    List<Item> itemList = List<Item>();

    for(int i=0;i< count ;i++){
      itemList.add(Item.fromMapObject(itemMapList[i]));
    }
    
    return itemList;
  }
}