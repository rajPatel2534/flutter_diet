import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/models/item.dart';
import 'package:login_demo/models/mineral.dart';
import 'package:login_demo/models/unit.dart';
import 'package:login_demo/models_with_obj/mineral_item_dto.dart';
import 'package:login_demo/utils/mineral_database_helper.dart';
import 'package:login_demo/utils/mineral_item_database_helper.dart';
import 'package:login_demo/utils/unit_database_helper.dart';

class AddMineralItem extends StatefulWidget{

  Item item;
  String title;
  AddMineralItem(this.item,this.title);
  @override
  State<StatefulWidget> createState() {
    return _AddMineralItemState(item,title);
  }


}

class _AddMineralItemState extends State<AddMineralItem>{

  Item item;
  MineralItemWithObj mineralItemWithObj;
  String title;
  List<Unit> unitList = List();
  List<Mineral> mineralList = List();

  List<MineralItemWithObj> listOfMineralItemObj = List<MineralItemWithObj>();
  List<TextEditingController> quantityController = List<TextEditingController>();
  // TextEditingController mineralDailyIntakeController = TextEditingController();
  MineralDatabaseHelper mineralDatabaseHelper = MineralDatabaseHelper(); 
  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();
  MineralItemDatabaseHelper mineralItemDatabaseHelper = MineralItemDatabaseHelper();

  _AddMineralItemState(this.item,this.title);

  var _units = ['milligrams' , 'micrograms'];
  String selected;

  @override
  Widget build(BuildContext context) {
    // mineralDailyIntakeController.text = item.dailyIntake;
    // mineralNameController.text = mineral.name;
    mineralItemWithObj.item = item;
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
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: getMineralsListView(),
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

  Widget getMineralsListView( ){

    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: listOfMineralItemObj.length,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: Text(listOfMineralItemObj[position].mineral.name),
            title: TextField(
              decoration: InputDecoration(
                labelText: 'Quantity',
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0) 
              )
              ),
              controller: quantityController[position],
            ),
            subtitle: Row(
              children: <Widget>[
                 DropdownButton(
            items: mineralList.map((dropDownItem){
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
           DropdownButton(
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
          )
              ],
            ),
          ),
        );
      },
    );
  }

  void getUnitList(){
    Future<List<Unit>> itemListFuture = unitDatabaseHelper.getNoteList();
        itemListFuture.then((itemList){
          setState(() {
            debugPrint('${itemList[0].id}');
            this.unitList = itemList;
            // this.selected = getUnitById(mineral.unitId);
            // this.count = itemList.length;
          });
        });
  }

   void getMineralList(){
    Future<List<Mineral>> mineralListFuture = mineralDatabaseHelper.getNoteList();
        mineralListFuture.then((mineralList){
          setState(() {
            debugPrint('${mineralList[0].id}');
            this.mineralList = mineralList;
            // this.selected = getUnitById(mineral.unitId);
            // this.count = itemList.length;
          });
        });
  }

  void updateName(){
    // mineral.name = mineralNameController.text;
  }

  void updateIntake(){
    // mineral.dailyIntake = mineralDailyIntakeController.text;
  }
  
  String getUnitById(int id){
    Unit unit = unitList.firstWhere((unit) => unit.id == id, orElse:() => null);
    if(unit != null) return unit.name; 
    else 
    {
      // mineral.unitId = unitList[0].id;
      return unitList[0].name;
  
  }}

  void updateSelectedUnit(String valueSelected){
    Unit unit = unitList.firstWhere((unit) => unit.name == valueSelected, orElse: null);
    // mineral.unitId = unit.id;
    this.selected = valueSelected;
  }

  void _save() async{
    var result;
  // if(item.id != null){
  //   result =  await mineralDatabaseHelper.updateNote(item);
  //   }
  //   else{
  //        result =  await mineralDatabaseHelper.insertNote(item);
  //   }


    if(result != 0) {
      moveToLastScreen(); 
      _showAlertDialog('Status','Note Saved Succesfully');
    }
    else _showAlertDialog('Status', 'Problem Saving Note');
  }

  void _delete() async{
    moveToLastScreen();
    if(item.id == null){
       _showAlertDialog('Status','No Note was Deleted');
      return;
    }
    int result = await mineralDatabaseHelper.deleteNote(item.id);
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