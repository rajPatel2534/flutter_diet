

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_demo/models/note.dart';
import 'package:login_demo/utils/database_helper.dart';

class NoteDetail extends StatefulWidget{

  String appBarTitle;
  Note note;
  NoteDetail(this.note,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _NoteDetailState(this.note,this.appBarTitle);
  }
}

class _NoteDetailState extends State<NoteDetail>{

  String appBarTitle;
  Note note;
  _NoteDetailState(this.note,this.appBarTitle);
  DatabaseHelper databaseHelper = DatabaseHelper();

  var _priorites = ['High','Low'];  
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController(); 
  
  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    detailController.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: getBody(),
      ),
    );
  }

  ListView getBody(){
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView(
      children: <Widget>[
        ListTile(
          title: DropdownButton(
            items: _priorites.map((String dropDownItem){
              return DropdownMenuItem<String>(
                value: dropDownItem,
                child: Text(dropDownItem),
              );
            }).toList(),

            style: textStyle,
            value: priorityAsString(note.priority),
            onChanged: (valueSelected){
              setState(() {
                updatePriorityAsInt(valueSelected);
              });
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: TextField(
            controller: titleController,
            style: textStyle,
            onChanged: (value){
              updateTitle();
            },
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0) 
              )
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: TextField(
            controller: detailController,
            style: textStyle,
            onChanged: (value){
              updateDescription();
            },
            decoration: InputDecoration(
              labelText: 'Description',
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
     );
  }
  

  updatePriorityAsInt(String value){
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'High':
        note.priority = 2;
        break;
    }
  }

  String priorityAsString(int value){
    String priority;
    switch (value) {
      case 1:
        priority = _priorites[0];
        break;
      case 2:
        priority = _priorites[1];
        break;
    }

    return priority;
  }

  void updateTitle(){
    note.title = titleController.text;
  }

  void updateDescription(){
    note.description = detailController.text;
  }

  void _save() async{
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null){
    result =  await databaseHelper.updateNote(note);
    }
    else{
         result =  await databaseHelper.insertNote(note);
    }

    if(result != 0) _showAlertDialog('Status','Note Saved Succesfully');
    else _showAlertDialog('Status', 'Problem Saving Note');
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

  void _delete() async{
    moveToLastScreen();
    if(note.id == null){
       _showAlertDialog('Status','No Note was Deleted');
      return;
    }
    int result = await databaseHelper.deleteNote(note.id);
    if(result != 0) _showAlertDialog('Status', 'Note Deleted Successfully');
    else _showAlertDialog('Status', 'Error occured while deleting note');
  }
}