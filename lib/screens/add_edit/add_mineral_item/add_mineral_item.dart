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
  String title;
  List<Unit> unitList = List();
  List<Mineral> mineralList = List();

  List<MineralItemWithObj> listOfMineralItemObj = List<MineralItemWithObj>();
  List<TextEditingController> quantityController = List<TextEditingController>();
  // TextEditingController mineralDailyIntakeController = TextEditingController();
  MineralDatabaseHelper mineralDatabaseHelper = MineralDatabaseHelper(); 
  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();
  MineralItemDatabaseHelper mineralItemDatabaseHelper = MineralItemDatabaseHelper();

  _AddMineralItemState(this.item,this.title){
  
        getUnitList();
    getMineralList();
    getListOfMineralItemWithObj();
  }

  var _units = ['milligrams' , 'micrograms'];
  String selected;
  List<String> selectedUnits = List<String>();
  List<String> selectedMinerals = List<String>();

  @override
  Widget build(BuildContext context) {
    // mineralDailyIntakeController.text = item.dailyIntake;
    // mineralNameController.text = mineral.name;
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child:ListView(
          children: <Widget>[

        Padding(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: RaisedButton(
            onPressed: (){
              addMineralChild();
            },
            child: Text('Add Mineral'),
          ),
        ),
        
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
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
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
              onChanged: (value){
                debugPrint('changed');
                updateQuantity(position);
              },
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
            hint: Text('Select Mineral'),
            style: textStyle,
            value: selectedMinerals[position],
            onChanged: (valueSelected){
              setState(() {
                debugPrint('$valueSelected selected');
                // updatePriorityAsInt(valueSelected);
                updateSelectedMineral(valueSelected,position);
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
            hint: Text('Select Unit'),
            style: textStyle,
            value: selectedUnits[position],
            onChanged: (valueSelected){
              setState(() {
                debugPrint('$valueSelected selected');
                // updatePriorityAsInt(valueSelected);
                updateSelectedUnit(valueSelected,position);
              });
            },
          )
              ],
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete_outline),
              onTap: (){
                deleteMineralItemObjFromList(position);
              },
            ),

            )
          );
      },
    );
  }

  void getUnitList(){
    Future<List<Unit>> itemListFuture = unitDatabaseHelper.getNoteList();
        itemListFuture.then((itemList){
          setState(() {
            this.unitList = itemList;
          });
        });
  }

   void getMineralList(){
    Future<List<Mineral>> mineralListFuture = mineralDatabaseHelper.getNoteList();
        mineralListFuture.then((mineralList){
          setState(() {
            this.mineralList = mineralList;
          });
        });
  }

   void getListOfMineralItemWithObj(){
    Future<List<MineralItemWithObj>> mineralListFuture = mineralItemDatabaseHelper.getMineralItemListWithObj(item.id);
        mineralListFuture.then((mineralListFuture){
          setState(() {
            listOfMineralItemObj = mineralListFuture;
            for(int i=0;i < listOfMineralItemObj.length ;i++){
              quantityController.add(TextEditingController(text: '${listOfMineralItemObj[i].quantity}'));
              selectedMinerals.add('${listOfMineralItemObj[i].mineral.name}');
              selectedUnits.add('${listOfMineralItemObj[i].unit.name}');
            }
          });
        });
  }

  void addMineralChild(){
    setState(() {
      this.listOfMineralItemObj.add(MineralItemWithObj(Mineral('', '0',null),item,0,Unit('')));
      quantityController.add(TextEditingController());
      selectedMinerals.add(null);
      selectedUnits.add(null);

    });
  }

  void deleteMineralItemObjFromList(int position) async{
    int result  = await mineralItemDatabaseHelper.deleteNote(listOfMineralItemObj[position].id);
    if(result == 1){
      _showAlertDialog('Status', 'Mineral Deleted Successfully');
       setState(() {
        listOfMineralItemObj.removeAt(position);
        quantityController.removeAt(position);
        selectedMinerals.removeAt(position);
        selectedUnits.removeAt(position);      
      });
    }
  }

  void updateQuantity(int position){
    listOfMineralItemObj[position].quantity = int.parse(quantityController[position].text) ;
  }
  
  void updateSelectedUnit(String valueSelected,position){
    Unit unit = unitList.firstWhere((unit) => unit.name == valueSelected, orElse: null);
    // mineral.unitId = unit.id;
    this.selectedUnits[position] = valueSelected;
    this.listOfMineralItemObj[position].unit = unit;

  }

  void updateSelectedMineral(String valueSelected,position){
    Mineral mineral = mineralList.firstWhere((unit) => unit.name == valueSelected, orElse: null);
    // mineral.unitId = unit.id;
    this.selectedMinerals[position] = valueSelected;
    this.listOfMineralItemObj[position].mineral = mineral;
  }


  void _save() async{
    var result;
    mineralItemDatabaseHelper.saveMineralItemObjList(listOfMineralItemObj);
    if(result != 0) {
      moveToLastScreen(); 
      _showAlertDialog('Status','Note Saved Succesfully');
    }
    else _showAlertDialog('Status', 'Problem Saving Note');

    
  }

  void _delete() async{

    bool result = true;
    for(int i=0;i< this.listOfMineralItemObj.length ; i++){
      int res = await mineralItemDatabaseHelper.deleteNote(this.listOfMineralItemObj[i].id);
      if(res != -1) result = false;
    }
    moveToLastScreen();
    if(result != false) _showAlertDialog('Status', 'Item Deleted Successfully');
    else _showAlertDialog('Status', 'Error occured while deleting Item');
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