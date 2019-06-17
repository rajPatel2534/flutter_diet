import 'package:login_demo/models/unit.dart';
import 'package:login_demo/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class UnitDatabaseHelper{
  static UnitDatabaseHelper _unitDatabaseHelper;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String unitTable = 'units';
  String unitId = 'unit_id';
  String unitName = 'unit_name';

 UnitDatabaseHelper._createInstance();

factory UnitDatabaseHelper(){
    //For singleton obj
    if(_unitDatabaseHelper == null){
    _unitDatabaseHelper = UnitDatabaseHelper._createInstance();
    }
    return _unitDatabaseHelper;
  } 



  Future<List<Map<String, dynamic>>> getUnitListMap() async{
    Database db = await _databaseHelper.database;
    var result = await db.query(unitTable,orderBy: '$unitId ASC');
    return result;
  }

  Future<int> insertUnit(Unit unit) async{
      Database db = await _databaseHelper.database;;
      var result = await db.insert(unitTable, unit.toMap());
      return result;
  }

  Future<int> updateUnit(Unit unit) async{
      Database db = await _databaseHelper.database;;
      var result = await db.update(unitTable, unit.toMap(),where: '$unitId = ?', whereArgs: [unit.id]);
      return result;
  }

    Future<int> deleteUnit(int id) async{
      Database db = await _databaseHelper.database;;
      var result = await db.rawDelete('DELETE FROM $unitTable WHERE $unitId = $id');
      return result;
  }

  Future<int> getCount(int id) async{
      Database db = await _databaseHelper.database;;
      List<Map<String, dynamic>> units = await db.rawQuery("SELECT COUNT (*) FROM $unitTable");
      int unitsLength = Sqflite.firstIntValue(units);
      return unitsLength;
  }

  Future<Unit> getUnit(int id) async{
    Database db = await _databaseHelper.database;
    List<Map<String,dynamic>> units = await db.rawQuery("SELECT * FROM $unitTable WHERE $unitId = $id");
   return Unit.fromMapObject(units[0]);
  }

  Future<List<Unit>> getUnitList() async{
    var unitMapList = await getUnitListMap();
    int count = unitMapList.length;
    List<Unit> unitList = List<Unit>();

    for(int i=0;i< count ;i++){
      unitList.add(Unit.fromMapObject(unitMapList[i]));
    }
    
    return unitList;
  }
}