
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/models/item.dart';
import 'package:login_demo/screens/add_edit/add_item/add_item.dart';
import 'package:login_demo/screens/add_edit/add_mineral_item/add_mineral_item.dart';
import 'package:login_demo/utils/item_database_helper.dart';

class ItemList extends StatefulWidget{
  ItemList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ItemListState();
  }

}

class ItemListState extends State<ItemList>{

  ItemDatabaseHelper itemDatabaseHelper = ItemDatabaseHelper();
  List<Item> itemList;
  int count = 0;
  var addThings = ['Item' , 'Mineral' , 'Unit'];

  @override
  Widget build(BuildContext context) {
    if(itemList == null){
      itemList = List<Item>();
      updateListView();
    }
    return 
     Container(
      child: getItemListView()
    );
  }


  ListView getItemListView(){
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
                this.itemList[position].name,
                style: textStyle,
              ),
              // subtitle: Text(
              //   this.itemList[position].description
              // ),
              trailing: GestureDetector( 
              onTap: (){
                _delete(context, itemList[position]);
                updateListView();
              },
              child :  Icon(Icons.delete)),
              onTap: (){
                navigateToAddMineralItemScreen(itemList[position],'Edit Item');
              },
            ),
          );
      },
    );
  }

  void navigateToNextScreen(Item item,String title) async{
  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddItem(item,title);
                }));
  if(result == true) updateListView();
  }

void navigateToAddMineralItemScreen(Item item,String title) async{
  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddMineralItem(item,title);
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

  void _delete(BuildContext context, Item item) async{
    int result = await itemDatabaseHelper.deleteItem(item.id);
    if(result != 0){
      _showSnackBar(context,'Item Deleted Successfully');
    }
  }

  void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void updateListView(){
        Future<List<Item>> itemListFuture = itemDatabaseHelper.getItemList();
        itemListFuture.then((itemList){
          setState(() {
            this.itemList = itemList;
            this.count = itemList.length;
          });
        });
    
  }
}