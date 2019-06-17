import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/models/unit.dart';
import 'package:login_demo/utils/color.dart';
import 'package:login_demo/utils/unit_database_helper.dart';

class AddUnit extends StatefulWidget {
  Unit unit;
  String title;

  AddUnit(this.unit, this.title);
  @override
  State<StatefulWidget> createState() {
    return _AddUnitState(unit, title);
  }
}

class _AddUnitState extends State<AddUnit> {
  Unit unit;
  String title;
  TextEditingController unitNameController = TextEditingController();
  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();
  Color themeColor = ColorHelper.themeColor;
  _AddUnitState(this.unit, this.title);

  @override
  Widget build(BuildContext context) {
    unitNameController.text = unit.name;
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
                    controller: unitNameController,
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
    unit.name = unitNameController.text;
  }

  void _save() async {
    var result;
    if (unit.id != null) {
      result = await unitDatabaseHelper.updateUnit(unit);
    } else {
      result = await unitDatabaseHelper.insertUnit(unit);
    }

    if (result != 0) {
      moveToLastScreen();
      _showAlertDialog('Status', 'Unit Saved Succesfully');
    } else
      _showAlertDialog('Status', 'Problem Saving Unit');
  }

  void _delete() async {
    moveToLastScreen();
    if (unit.id == null) {
      _showAlertDialog('Status', 'No Unit was Deleted');
      return;
    }
    int result = await unitDatabaseHelper.deleteUnit(unit.id);
    if (result != 0)
      _showAlertDialog('Status', 'Unit Deleted Successfully');
    else
      _showAlertDialog('Status', 'Error occured while deleting unit');
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
