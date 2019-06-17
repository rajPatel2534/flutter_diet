

import 'package:login_demo/models/mineral.dart';
import 'package:login_demo/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class MineralDatabaseHelper{
  static MineralDatabaseHelper _mineralDatabaseHelper;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String mineralTable = 'minerals';
  String mineralId = 'mineral_id';
  String itemName = 'mineral_name';
  String dailyIntake = 'daily_intake';
  String unit = 'unit';

 MineralDatabaseHelper._createInstance();

factory MineralDatabaseHelper(){
    //For singleton obj
    if(_mineralDatabaseHelper == null){
    _mineralDatabaseHelper = MineralDatabaseHelper._createInstance();
    }
    return _mineralDatabaseHelper;
  } 



  Future<List<Map<String, dynamic>>> getMineralListMap() async{
    Database db = await _databaseHelper.database;
    var result = await db.query(mineralTable,orderBy: '$mineralId ASC');
    return result;
  }

  Future<int> insertMineral(Mineral mineral) async{
      Database db = await _databaseHelper.database;;
      var result = await db.insert(mineralTable, mineral.toMap());
      return result;
  }

  Future<int> updateMineral(Mineral mineral) async{
      Database db = await _databaseHelper.database;;
      var result = await db.update(mineralTable, mineral.toMap(),where: '$mineralId = ?', whereArgs: [mineral.id]);
      return result;
  }

    Future<int> deleteMineral(int id) async{
      Database db = await _databaseHelper.database;;
      var result = await db.rawDelete('DELETE FROM $mineralTable WHERE $mineralId = $id');
      return result;
  }

  Future<int> getCount(int id) async{
      Database db = await _databaseHelper.database;;
      List<Map<String, dynamic>> minerals = await db.rawQuery("SELECT COUNT (*) FROM $mineralTable");
      int mineralsLength = Sqflite.firstIntValue(minerals);
      return mineralsLength;
  }

  Future<Mineral> getMineral(int id) async{
    Database db = await _databaseHelper.database;
    List<Map<String,dynamic>> mineral = await db.rawQuery("SELECT * FROM $mineralTable WHERE $mineralId = $id");
   return Mineral.fromMapObject(mineral[0]);
  }

  Future<List<Mineral>> getMineralList() async{
    var mineralMapList = await getMineralListMap();
    int count = mineralMapList.length;
    List<Mineral> mineralList = List<Mineral>();

    for(int i=0;i< count ;i++){
      mineralList.add(Mineral.fromMapObject(mineralMapList[i]));
    }
    
    return mineralList;
  }
}