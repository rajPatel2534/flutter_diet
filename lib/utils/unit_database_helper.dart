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



  Future<List<Map<String, dynamic>>> getNoteListMap() async{
    Database db = await _databaseHelper.database;
    var result = await db.query(unitTable,orderBy: '$unitId ASC');
    return result;
  }

  Future<int> insertNote(Unit note) async{
      Database db = await _databaseHelper.database;;
      var result = await db.insert(unitTable, note.toMap());
      return result;
  }

  Future<int> updateNote(Unit note) async{
      Database db = await _databaseHelper.database;;
      var result = await db.update(unitTable, note.toMap(),where: '$unitId = ?', whereArgs: [note.id]);
      return result;
  }

    Future<int> deleteNote(int id) async{
      Database db = await _databaseHelper.database;;
      var result = await db.rawDelete('DELETE FROM $unitTable WHERE $unitId = $id');
      return result;
  }

  Future<int> getCount(int id) async{
      Database db = await _databaseHelper.database;;
      List<Map<String, dynamic>> notes = await db.rawQuery("SELECT COUNT (*) FROM $unitTable");
      int notesLength = Sqflite.firstIntValue(notes);
      return notesLength;
  }

  Future<Unit> getUnit(int id) async{
    Database db = await _databaseHelper.database;
    List<Map<String,dynamic>> units = await db.rawQuery("SELECT * FROM $unitTable WHERE $unitId = $id");
   return Unit.fromMapObject(units[0]);
  }

  Future<List<Unit>> getNoteList() async{
    var noteMapList = await getNoteListMap();
    int count = noteMapList.length;
    List<Unit> noteList = List<Unit>();

    for(int i=0;i< count ;i++){
      noteList.add(Unit.fromMapObject(noteMapList[i]));
    }
    
    return noteList;
  }
}