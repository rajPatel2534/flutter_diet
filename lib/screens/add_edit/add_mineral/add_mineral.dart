import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/models/mineral.dart';
import 'package:login_demo/models/unit.dart';
import 'package:login_demo/utils/mineral_database_helper.dart';
import 'package:login_demo/utils/unit_database_helper.dart';

class AddMineral extends StatefulWidget{

  Mineral mineral;
  String title;
  AddMineral(this.mineral,this.title);
  @override
  State<StatefulWidget> createState() {
    return _AddMineralState(mineral,title);
  }


}

class _AddMineralState extends State<AddMineral>{

  Mineral mineral;
  String title;
  List<Unit> unitList = List();
  TextEditingController mineralNameController = TextEditingController();
  TextEditingController mineralDailyIntakeController = TextEditingController();
  MineralDatabaseHelper mineralDatabaseHelper = MineralDatabaseHelper(); 
  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();

  _AddMineralState(this.mineral,this.title);

  var _units = ['milligrams' , 'micrograms'];
  String selected;

  @override
  Widget build(BuildContext context) {
    mineralDailyIntakeController.text = mineral.dailyIntake;
    mineralNameController.text = mineral.name;
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    getUnitList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child:Column(
          children: <Widget>[

            Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: TextField(
            controller: mineralNameController,
            style: textStyle,
            onChanged: (value){
              updateName();
            },
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0) 
              )
            ),
          ),
        ),
        
        Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
            controller: mineralDailyIntakeController,
            style: textStyle,
            onChanged: (value){
              updateIntake();
            },
            decoration: InputDecoration(
              labelText: 'Amount of daily intake',
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0) 
              )
            ),
          ),
              ),
              Container(
                width: 5.0,
              ),
               Expanded(
                child:  DropdownButton(
            items: unitList.map((dropDownItem){
              return DropdownMenuItem<String>(
                value: dropDownItem.name,
                child: Text(dropDownItem.name),
              );
            }).toList(),

            style: textStyle,
            value: selected,
            onChanged: (valueSelected){
              setState(() {
                debugPrint('$valueSelected selected');
                // updatePriorityAsInt(valueSelected);
                updateSelectedUnit(valueSelected);
              });
            },
          ),
              )
            ],
          ),
          )
          ,
        
            Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Save',
                  textScaleFactor: 1.5,),
                  onPressed: (){
                    _save();
                  },
                ),
              ),
              Container(
                width: 5.0,
              ),
               Expanded(
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Delete',
                  textScaleFactor: 1.5,),
                  onPressed: (){
                    _delete();
                  },
                ),
              )
            ],
          ),
          )
          ],
        ),
      ),
    );
  }

  void getUnitList(){
    Future<List<Unit>> itemListFuture = unitDatabaseHelper.getNoteList();
        itemListFuture.then((itemList){
          setState(() {
            debugPrint('${itemList[0].id}');
            this.unitList = itemList;
            this.selected = getUnitById(mineral.unitId);
            // this.count = itemList.length;
          });
        });
  }

  void updateName(){
    mineral.name = mineralNameController.text;
  }

  void updateIntake(){
    mineral.dailyIntake = mineralDailyIntakeController.text;
  }
  
  String getUnitById(int id){
    Unit unit = unitList.firstWhere((unit) => unit.id == id, orElse:() => null);
    if(unit != null) return unit.name; 
    else 
    {
      mineral.unitId = unitList[0].id;
      return unitList[0].name;
  
  }}

  void updateSelectedUnit(String valueSelected){
    Unit unit = unitList.firstWhere((unit) => unit.name == valueSelected, orElse: null);
    mineral.unitId = unit.id;
    this.selected = valueSelected;
  }

  void _save() async{
    var result;
  if(mineral.id != null){
    result =  await mineralDatabaseHelper.updateNote(mineral);
    }
    else{
         result =  await mineralDatabaseHelper.insertNote(mineral);
    }


    if(result != 0) {
      moveToLastScreen(); 
      _showAlertDialog('Status','Note Saved Succesfully');
    }
    else _showAlertDialog('Status', 'Problem Saving Note');
  }

  void _delete() async{
    moveToLastScreen();
    if(mineral.id == null){
       _showAlertDialog('Status','No Note was Deleted');
      return;
    }
    int result = await mineralDatabaseHelper.deleteNote(mineral.id);
    if(result != 0) _showAlertDialog('Status', 'Note Deleted Successfully');
    else _showAlertDialog('Status', 'Error occured while deleting note');
  }

  void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

  void moveToLastScreen() {
		Navigator.pop(context, true);
  } 


}