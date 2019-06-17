import 'package:flutter/material.dart';
import 'package:login_demo/models/item.dart';
import 'package:login_demo/utils/color.dart';
import 'package:login_demo/utils/item_database_helper.dart';

class AddItem extends StatefulWidget {
  Item item;
  String title;
  AddItem(this.item, this.title);
  @override
  State<StatefulWidget> createState() {
    return _AddItemState(item, title);
  }
}

class _AddItemState extends State<AddItem> {
  Item item;
  String title;
  TextEditingController itemNameController = TextEditingController();
  ItemDatabaseHelper itemDatabaseHelper = ItemDatabaseHelper();
  Color themeColor = ColorHelper.themeColor;
  _AddItemState(this.item, this.title);

  @override
  Widget build(BuildContext context) {
    itemNameController.text = item.name;
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: this.themeColor,
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Theme(
                  data: ThemeData(primaryColor: this.themeColor),
                  child: TextField(
                    controller: itemNameController,
                    style: textStyle,
                    onChanged: (value) {
                      updateName();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        _delete();
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: this.themeColor,
                      textColor: Colors.white,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        _save();
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

  void updateName() {
    item.name = itemNameController.text;
  }

  void _save() async {
    var result;
    if (item.id != null) {
      result = await itemDatabaseHelper.updateItem(item);
    } else {
      result = await itemDatabaseHelper.insertItem(item);
    }

    if (result != 0) {
      moveToLastScreen();
      _showAlertDialog('Status', 'Unit Saved Succesfully');
    } else
      _showAlertDialog('Status', 'Problem Saving Unit');
  }

  void _delete() async {
    moveToLastScreen();
    if (item.id == null) {
      _showAlertDialog('Status', 'No Unit was Deleted');
      return;
    }
    int result = await itemDatabaseHelper.deleteItem(item.id);
    if (result != 0)
      _showAlertDialog('Status', 'Unit Deleted Successfully');
    else
      _showAlertDialog('Status', 'Error occured while deleting Unit');
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
