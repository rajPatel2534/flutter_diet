import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/models/item.dart';
import 'package:login_demo/models/mineral.dart';
import 'package:login_demo/models/unit.dart';
import 'package:login_demo/models_with_obj/mineral_item_dto.dart';
import 'package:login_demo/utils/color.dart';
import 'package:login_demo/utils/item_database_helper.dart';
import 'package:login_demo/utils/mineral_database_helper.dart';
import 'package:login_demo/utils/mineral_item_database_helper.dart';
import 'package:login_demo/utils/unit_database_helper.dart';

class AddMineralItem extends StatefulWidget {
  Item item;
  String title;
  AddMineralItem(this.item, this.title);
  @override
  State<StatefulWidget> createState() {
    return _AddMineralItemState(item, title);
  }
}

class _AddMineralItemState extends State<AddMineralItem> {
  Item item;
  String title;
  List<Unit> unitList = List();
  List<Mineral> mineralList = List();

  List<MineralItemWithObj> listOfMineralItemObj = List<MineralItemWithObj>();
  List<TextEditingController> mineralQuantityController =
      List<TextEditingController>();
  List<TextEditingController> itemQuantityController =
      List<TextEditingController>();
  // TextEditingController mineralDailyIntakeController = TextEditingController();
  MineralDatabaseHelper mineralDatabaseHelper = MineralDatabaseHelper();
  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();
  ItemDatabaseHelper itemDatabaseHelper = ItemDatabaseHelper();
  MineralItemDatabaseHelper mineralItemDatabaseHelper =
      MineralItemDatabaseHelper();

  _AddMineralItemState(this.item, this.title) {
    getUnitList();
    getMineralList();
    getListOfMineralItemWithObj();
  }

  var _units = ['milligrams', 'micrograms'];
  Color themeColor = ColorHelper.themeColor;
  String selected;
  List<String> selectedItemUnits = List<String>();
  List<String> selectedMinerals = List<String>();
  List<String> selectedMineralUnits = List<String>();
  bool isDataLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: this.themeColor,
        title: Text(title),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: this.themeColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(color: this.themeColor)),
                              padding: EdgeInsets.all(5.0),
                              child: Row(children: <Widget>[
                                Text(
                                  'Add Mineral',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.add_box,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                )
                              ])),
                          onTap: () {
                            addMineralChild();
                          }),
                    ])),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child:  (isDataLoading == true)
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorHelper.themeColor),
            ),
          ) : getMineralsListView(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getMineralsListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: listOfMineralItemObj.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: Colors.grey[50])),
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.only(bottom: 5.0, top: 2.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          flex: 2,
                          child: Theme(
                              data: ThemeData(primaryColor: this.themeColor),
                              child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Quantity of item',
                                    labelStyle: textStyle,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                controller: itemQuantityController[position],
                                onChanged: (value) {
                                  updateItemQuantity(position);
                                },
                              ))),
                      Container(
                        width: 5.0,
                      ),
                      Flexible(
                          flex: 1,
                          child: DropdownButton(
                            isExpanded: true,
                            items: unitList.map((dropDownItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownItem.name,
                                child: Text(dropDownItem.name),
                              );
                            }).toList(),
                            hint: Text('Unit'),
                            style: textStyle,
                            value: selectedItemUnits[position],
                            onChanged: (valueSelected) {
                              setState(() {
                                updateSelectedItemUnit(valueSelected, position);
                              });
                            },
                          ))
                    ],
                  )),
              subtitle: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Color(this.themeColor.value),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    // border: Colors.white
                  ),
                  child: Column(
                    children: <Widget>[
                      DropdownButton(
                        items: mineralList.map((dropDownItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownItem.name,
                            child: Text(dropDownItem.name),
                          );
                        }).toList(),
                        hint: Text('Select Mineral'),
                        style: textStyle,
                        value: selectedMinerals[position],
                        onChanged: (valueSelected) {
                          setState(() {
                            updateSelectedMineral(valueSelected, position);
                          });
                        },
                      ),
                      Row(children: <Widget>[
                        Flexible(
                            flex: 2,
                            child: Theme(
                                data: ThemeData(primaryColor: this.themeColor),
                                child: TextField(
                                  decoration: InputDecoration(
                                      labelText: 'Quantity of Mineral',
                                      labelStyle: textStyle,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                  controller:
                                      mineralQuantityController[position],
                                  onChanged: (value) {
                                    updateMineralQuantity(position);
                                  },
                                ))),
                        Container(
                          width: 5.0,
                        ),
                        Flexible(
                            flex: 1,
                            child: DropdownButton(
                              isExpanded: true,
                              items: unitList.map((dropDownItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownItem.name,
                                  child: Text(dropDownItem.name),
                                );
                              }).toList(),
                              hint: Text('Unit'),
                              style: textStyle,
                              value: selectedMineralUnits[position],
                              onChanged: (valueSelected) {
                                setState(() {
                                  updateSelectedMineralUnit(
                                      valueSelected, position);
                                });
                              },
                            ))
                      ])
                    ],
                  )),
              trailing: GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: Colors.white)),
                    child: Icon(
                      Icons.delete_outline,
                      size: 30.0,
                      color: Colors.white,
                    )),
                onTap: () {
                  deleteMineralItemObjFromList(position);
                },
              ),
            ));
      },
    );
  }

  void getUnitList() {
    Future<List<Unit>> itemListFuture = unitDatabaseHelper.getUnitList();
    itemListFuture.then((itemList) {
      setState(() {
        this.unitList = itemList;
      });
    });
  }

  void getMineralList() {
    Future<List<Mineral>> mineralListFuture =
        mineralDatabaseHelper.getMineralList();
    mineralListFuture.then((mineralList) {
      setState(() {
        this.mineralList = mineralList;
      });
    });
  }

  void getListOfMineralItemWithObj() {
    Future<List<MineralItemWithObj>> mineralListFuture =
        mineralItemDatabaseHelper.getMineralItemListWithObj(item.id);
    mineralListFuture.then((mineralListFuture) {
      debugPrint('${mineralListFuture.length}');
      setState(() {
        listOfMineralItemObj = mineralListFuture;
        for (int i = 0; i < listOfMineralItemObj.length; i++) {
          mineralQuantityController.add(TextEditingController(
              text: '${listOfMineralItemObj[i].mineralQuantity}'));
          itemQuantityController.add(TextEditingController(
              text: '${listOfMineralItemObj[i].itemQuantity}'));
          selectedMinerals.add('${listOfMineralItemObj[i].mineral.name}');
          selectedMineralUnits
              .add('${listOfMineralItemObj[i].mineralUnit.name}');
          selectedItemUnits.add('${listOfMineralItemObj[i].itemUnit.name}');
        }
         isDataLoading = false;
      });
    });
  }

  void addMineralChild() {
    setState(() {
      this.listOfMineralItemObj.add(MineralItemWithObj(
          mineralList[0], item, 0, unitList[0], 0, unitList[0]));
      mineralQuantityController.add(TextEditingController());
      itemQuantityController.add(TextEditingController());
      selectedMinerals.add(mineralList[0].name);
      selectedMineralUnits.add(unitList[0].name);
      selectedItemUnits.add(unitList[0].name);
    });
  }

  void deleteMineralItemObjFromList(int position) async {
    int result = await mineralItemDatabaseHelper
        .deleteMineralItem(listOfMineralItemObj[position].id);
    if (result == 1) {
      _showAlertDialog('Status', 'Mineral Deleted Successfully');
      setState(() {
        listOfMineralItemObj.removeAt(position);
        mineralQuantityController.removeAt(position);
        selectedMinerals.removeAt(position);
        selectedItemUnits.removeAt(position);
        selectedMineralUnits.removeAt(position);
      });
    }
  }

  void updateMineralQuantity(int position) {
    listOfMineralItemObj[position].mineralQuantity =
        int.parse(mineralQuantityController[position].text);
  }

  void updateItemQuantity(int position) {
    listOfMineralItemObj[position].itemQuantity =
        int.parse(itemQuantityController[position].text);
  }

  void updateSelectedMineralUnit(String valueSelected, position) {
    Unit unit =
        unitList.firstWhere((unit) => unit.name == valueSelected, orElse: null);
    // mineral.unitId = unit.id;
    this.selectedMineralUnits[position] = valueSelected;
    this.listOfMineralItemObj[position].mineralUnit = unit;
  }

  void updateSelectedItemUnit(String valueSelected, position) {
    Unit unit =
        unitList.firstWhere((unit) => unit.name == valueSelected, orElse: null);
    // mineral.unitId = unit.id;
    this.selectedItemUnits[position] = valueSelected;
    this.listOfMineralItemObj[position].itemUnit = unit;
  }

  void updateSelectedMineral(String valueSelected, position) {
    Mineral mineral = mineralList
        .firstWhere((unit) => unit.name == valueSelected, orElse: null);
    // mineral.unitId = unit.id;
    this.selectedMinerals[position] = valueSelected;
    this.listOfMineralItemObj[position].mineral = mineral;
  }

  void _save() async {
    var result;
    mineralItemDatabaseHelper.saveMineralItemObjList(listOfMineralItemObj);
    if (result != 0) {
      moveToLastScreen();
      _showAlertDialog('Status', 'Data Saved Succesfully');
    } else
      _showAlertDialog('Status', 'Problem Saving Data');
  }

  void _delete() async {
    bool result = true;
    for (int i = 0; i < this.listOfMineralItemObj.length; i++) {
      int res = await mineralItemDatabaseHelper
          .deleteMineralItem(this.listOfMineralItemObj[i].id);
      if (res != 1) result = false;
    }
    if (result == true) {
      int res = await itemDatabaseHelper.deleteItem(item.id);
      if (res == 1) {
        moveToLastScreen();
        _showAlertDialog('Status', 'Item Deleted Successfully');
      } else
        _showAlertDialog('Status', 'Error occured while deleting Item');
    }
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
