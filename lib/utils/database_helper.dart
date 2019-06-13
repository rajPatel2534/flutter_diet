import 'package:login_demo/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  //SingleTon Object
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  //Unit table
  String unitTable = 'units';
  String unitId = 'unit_id';
  String unitName = 'unit_name';


  //Minerals table
  String mineralTable = 'minerals';
  String mineralId = 'mineral_id';
  String mineralName = 'mineral_name';
  String dailyIntake = 'daily_intake';
  String unit = 'unit';

  //Item table
  String itemTable = 'items';
  String itemId = 'item_id';
  String itemName = 'item_name';

  //Mineral Item Table
  String mineralItemTable = 'mineral_item';
  String mineralItemId = 'mineral_item_id';
  String mineralItemUnitId = 'unit_id';
  String mineralItemMineralId = 'mineral_id';
  String mineralItemItemId = 'item_id';
  String mineralItemMineralQuantity = 'quantity';


  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    //For singleton obj
    if(_databaseHelper == null){
    _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'databases/' + 'notes.db';

    //open database

    var notesDatabase = openDatabase(path,version: 2, onCreate: _createDb);
    return notesDatabase;
  }


  void _createDb(Database db,int newVersion) async{
    await db.execute('CREATE TABLE $unitTable($unitId INTEGER PRIMARY KEY AUTOINCREMENT,$unitName Text)');
    await db.execute('CREATE TABLE $itemTable($itemId INTEGER PRIMARY KEY AUTOINCREMENT,$itemName Text)');

    await db.execute('CREATE TABLE $mineralTable('
      '$mineralId INTEGER PRIMARY KEY AUTOINCREMENT,$mineralName Text,'
         '$dailyIntake Text,$unit INTEGER,'
        'FOREIGN KEY($unit) REFERENCES $unitTable($unitId))');   

   await db.execute('CREATE TABLE $mineralItemTable('
      '$mineralItemId INTEGER PRIMARY KEY AUTOINCREMENT,$mineralItemItemId INTEGER,'
         '$mineralItemMineralId INTEGER,$mineralItemMineralQuantity INTEGER,$mineralItemUnitId INTEGER'
        'FOREIGN KEY($mineralItemMineralId) REFERENCES $mineralTable($mineralId))'
        'FOREIGN KEY($mineralItemUnitId) REFERENCES $unitTable($unitId))'
        'FOREIGN KEY($mineralItemItemId) REFERENCES $itemTable($itemId))');    
  }

  Future<List<Map<String, dynamic>>> getNoteListMap() async{
    Database db = await this.database;
    var result = await db.query(noteTable,orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async{
      Database db = await this.database;
      var result = await db.insert(noteTable, note.toMap());
      return result;
  }

  Future<int> updateNote(Note note) async{
      Database db = await this.database;
      var result = await db.update(noteTable, note.toMap(),where: '$colId = ?', whereArgs: [note.id]);
      return result;
  }

    Future<int> deleteNote(int id) async{
      Database db = await this.database;
      var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
      return result;
  }

  Future<int> getCount(int id) async{
      Database db = await this.database;
      List<Map<String, dynamic>> notes = await db.rawQuery("SELECT COUNT (*) FROM $noteTable");
      int notesLength = Sqflite.firstIntValue(notes);
      return notesLength;
  }

  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteListMap();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();

    for(int i=0;i< count ;i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    
    return noteList;
  }

}