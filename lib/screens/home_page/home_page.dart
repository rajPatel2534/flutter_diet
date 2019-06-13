import 'package:flutter/material.dart';
import 'package:login_demo/models/item.dart';
import 'package:login_demo/models/mineral.dart';
import 'package:login_demo/models/note.dart';
import 'package:login_demo/models/unit.dart';
import 'package:login_demo/screens/add_edit/add_item/add_item.dart';
import 'package:login_demo/screens/add_edit/add_mineral/add_mineral.dart';
import 'package:login_demo/screens/add_edit/add_unit/add_unit.dart';
import 'package:login_demo/screens/list_of_all/item_list/item_list.dart';
import 'package:login_demo/screens/list_of_all/mineral_list/mineral_list.dart';
import 'package:login_demo/screens/list_of_all/unit_list/unit_list.dart';
import 'package:login_demo/screens/note_detail/note_detail.dart';
import 'package:login_demo/utils/database_helper.dart';
import 'package:login_demo/utils/item_database_helper.dart';
import 'package:login_demo/utils/mineral_database_helper.dart';
import 'package:login_demo/utils/unit_database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

  DatabaseHelper databaseHelper = DatabaseHelper();
  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();
  MineralDatabaseHelper mineralDatabaseHelper = MineralDatabaseHelper();
  ItemDatabaseHelper itemDatabaseHelper = ItemDatabaseHelper();
  List<Note> noteList;

  GlobalKey<ItemListState> itemGlobalKey = GlobalKey();
  GlobalKey<UnitListState> unitGlobalKey = GlobalKey();
  GlobalKey<MineralListState> mineralGlobalKey = GlobalKey();

  int count = 0;
  var addThings = ['Item' , 'Mineral' , 'Unit'];

  @override
  Widget build(BuildContext context){

    if(noteList == null){
      noteList = List<Note>();
      // updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        
        title:Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 3.0),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                
              children : <Widget>[RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600
                ),
              ),
              onPressed: (){
                // Navigator.pop(context);
                logout(context);
              },
            )]
            )
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        //  navigateToNextScreen(Note('','',2), 'Add Note');
          showOptionDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add note',
      ),
      body: 
     Container(
      child: ListView(
        children: <Widget>[
          getWidgetsByTitle('Items'),
          getWidgetsByTitle('Units'),
          getWidgetsByTitle('Minerals')
        ],
      )
    ));

  }


  Widget getWidgetsByTitle(String title){
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.only(bottom: 5.0),
          color: Colors.blueAccent,
          
          child : Center(
            
            child : Text(
            title,
            style: TextStyle(
              // backgroundColor: Colors.blueAccent,
                fontSize: 20.0,
                color: Colors.white              
            ),
          )
          )),
          getListByTitle(title)
        ],
      ),
    );
  }

  Widget getListByTitle(String title){
    switch (title) {
      case 'Items':
        return ItemList(key : itemGlobalKey);
      case 'Units':
        return UnitList(key : unitGlobalKey); 
      case 'Minerals':
        return MineralList(key : mineralGlobalKey);
    }
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
                backgroundColor: getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
                
              ),
              title: Text(
                this.noteList[position].title,
                style: textStyle,
              ),
              subtitle: Text(
                this.noteList[position].description
              ),
              trailing: GestureDetector( 
              onTap: (){
                _delete(context, noteList[position]);
                updateListView();
              },
              child :  Icon(Icons.delete)),
              onTap: (){
                navigateToNextScreen(noteList[position],'Edit Note');
              },
            ),
          );
      },
    );
  }

  void navigateToNextScreen(Note note,String title) async{
  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return NoteDetail(note,title);
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

  void _delete(BuildContext context, Note note) async{
    int result = await databaseHelper.deleteNote(note.id);
    if(result != 0){
      _showSnackBar(context,'Note Deleted Successfully');
    }
  }

  void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void updateListView(){
    itemGlobalKey.currentState.updateListView();
    unitGlobalKey.currentState.updateListView();
    mineralGlobalKey.currentState.updateListView();
    // ItemList().
    // dbFuture.then((database){
    //     Future<List<Item>> itemList = itemDatabaseHelper.getNoteList();
    //     Future<List<Unit>> unitList = unitDatabaseHelper.getNoteList();
    //     Future<List<Mineral>> mineralList = mineralDatabaseHelper.getNoteList();
    //     // Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
    //     // noteListFuture.then((noteList){
    //     //   setState(() {
    //     //     this.noteList = noteList;
    //     //     this.count = noteList.length;
    //     //   });
    //     // });
    // });
  }

void logout(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isLoggedIn', false);
    // var route = ModalRoute.of(context);
     Navigator.of(context)
    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

  }

void showOptionDialog(BuildContext context){
showDialog(
        context: context,
        builder: (_) => new SimpleDialog(
            title: new Text(
              'Choose Thing To Add'
            ),
            children: <Widget>[ 

              getSimpleDialogOption(addThings[0]),
              getSimpleDialogOption(addThings[1]),
              getSimpleDialogOption(addThings[2])
            ],)
        //     content: Container(
        //     child : ListView(
        //     children : <Widget>[ ListTile(
        //       title: Text(
        //         'hi'
        //       ),
        //       leading: Icon(Icons.access_time),
        //     )
        // ])))
    );
}

ListView getOptionsListView(){
 return ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context , int position){
                return ListTile(
                  leading: Icon(Icons.plus_one),
                  title: Text(
                    '${addThings[position]}'
                  ),
                );
              });
            
}

SimpleDialogOption getSimpleDialogOption(String itemName){
  return SimpleDialogOption(
    child: ListTile(
      title : Text(
      '$itemName'
      ),
      leading: Icon(Icons.access_alarm),
    ),
    onPressed: (){
      Navigator.pop(context,itemName);
      clickOnDialog(itemName);
    },
  );
}

clickOnDialog(String itemName){
  String a= 'aa';
  switch(itemName){
    case 'Item' :
      navigateToNewItemScreen(Item(''), 'Add Item');
      break;
    case 'Mineral' :
      navigateToNewMineralScreen(Mineral('','0',0), 'Add Mineral');
      break;
    case 'Unit' : 
      navigateToNewUnitScreen(Unit(''), 'Add Item');
      break;  
  }
}

navigateToNewItemScreen(Item item,String title) async{

  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddItem(item,title);
                }));
  if(result == true) updateListView();

}
navigateToNewMineralScreen(Mineral mineral , String title) async{

  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddMineral(mineral,title);
                }));
  if(result == true) updateListView();
}
navigateToNewUnitScreen(Unit unit, String title) async{

  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddUnit(unit,title);
                }));
  if(result == true) updateListView();
}

}