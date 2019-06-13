
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/models/unit.dart';
import 'package:login_demo/screens/add_edit/add_unit/add_unit.dart';
import 'package:login_demo/utils/unit_database_helper.dart';

class UnitList extends StatefulWidget{
  UnitList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UnitListState();
  }

}

class UnitListState extends State<UnitList>{

  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();
  List<Unit> unitList;
  int count = 0;
  var addThings = ['Item' , 'Mineral' , 'Unit'];

  @override
  Widget build(BuildContext context) {
    if(unitList == null){
      unitList = List<Unit>();
      updateListView();
    }
    return 
     Container(
      child: getNoteListView()
    );
  }


  ListView getNoteListView(){
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: count ,
      itemBuilder: (BuildContext context, int position){
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.account_circle),
                
              ),
              title: Text(
                this.unitList[position].name,
                style: textStyle,
              ),
              // subtitle: Text(
              //   this.unitList[position].description
              // ),
              trailing: GestureDetector( 
              onTap: (){
                _delete(context, unitList[position]);
                updateListView();
              },
              child :  Icon(Icons.delete)),
              onTap: (){
                navigateToNextScreen(unitList[position],'Edit Unit');
              },
            ),
          );
      },
    );
  }

  void navigateToNextScreen(Unit unit,String title) async{
  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddUnit(unit,title);
                }));
  if(result == true) updateListView();
  }


  Color getPriorityColor(int priority){
    switch (priority) {
      case 1:
        return Colors.blue;  
        break;
      case 2:
        return Colors.yellow;
        break;  
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority){
    switch (priority) {
      case 1:
        return Icon(Icons.keyboard_arrow_right);  
        break;
      case 2:
        return Icon(Icons.play_arrow);
        break;  
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Unit unit) async{
    int result = await unitDatabaseHelper.deleteNote(unit.id);
    if(result != 0){
      _showSnackBar(context,'Unit Deleted Successfully');
    }
  }

  void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void updateListView(){
        Future<List<Unit>> unitListFuture = unitDatabaseHelper.getNoteList();
        unitListFuture.then((unitList){
          setState(() {
            this.unitList = unitList;
            this.count = unitList.length;
          });
        });
  }
}