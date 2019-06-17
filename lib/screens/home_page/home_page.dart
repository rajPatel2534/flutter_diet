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
import 'package:login_demo/screens/settings/settings_home/setting_home.dart';
import 'package:login_demo/utils/color.dart';
import 'package:login_demo/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int _selectedBarItem = 0;

  GlobalKey<ItemListState> itemGlobalKey = GlobalKey();
  GlobalKey<UnitListState> unitGlobalKey = GlobalKey();
  GlobalKey<MineralListState> mineralGlobalKey = GlobalKey();
  static List<Widget> _bottomNavigationBarItems;
  Color themeColor = ColorHelper.themeColor;

  _HomePageState() {
    _bottomNavigationBarItems = <Widget>[
      ItemList(key: itemGlobalKey),
      MineralList(key: mineralGlobalKey),
      UnitList(key: unitGlobalKey),
      SettingHome()
    ];
  }

  List<Note> noteList;

  int count = 0;
  var addThings = ['Item', 'Mineral', 'Unit'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedBarItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 3.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      RaisedButton(
                        textColor: Colors.white,
                        color: ColorHelper.themeColor,
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          logout(context);
                        },
                      )
                    ]))
          ],
        ),
        backgroundColor: ColorHelper.themeColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorHelper.themeColor ,
        onPressed: () {
          showOptionDialog(context);
        },
        child: Icon(
          Icons.add,
        ),
        tooltip: 'Add note',
      ),
      body: Container(
          child: _bottomNavigationBarItems.elementAt(_selectedBarItem)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), title: Text('Items')),
          BottomNavigationBarItem(
              icon: Icon(Icons.filter_vintage), title: Text('Minerals')),
          BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit), title: Text('Units')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))              
        ],
        selectedItemColor: ColorHelper.themeColor,
        currentIndex: _selectedBarItem,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    if (_selectedBarItem == 0)
      itemGlobalKey.currentState.updateListView();
    else if (_selectedBarItem == 1)
      mineralGlobalKey.currentState.updateListView();
    else
      unitGlobalKey.currentState.updateListView();
  }

  void logout(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isLoggedIn', false);
    // var route = ModalRoute.of(context);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  void showOptionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new SimpleDialog(
              title: new Text('Choose Thing To Add'),
              children: <Widget>[
                getSimpleDialogOption(addThings[0]),
                getSimpleDialogOption(addThings[1]),
                getSimpleDialogOption(addThings[2])
              ],
            )
        );
  }

  ListView getOptionsListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (BuildContext context, int position) {
          return ListTile(
            leading: Icon(Icons.plus_one),
            title: Text('${addThings[position]}'),
          );
        });
  }

  SimpleDialogOption getSimpleDialogOption(String itemName) {
    return SimpleDialogOption(
      child: ListTile(
        title: Text('$itemName'),
        leading: Icon(Icons.access_alarm),
      ),
      onPressed: () {
        Navigator.pop(context, itemName);
        clickOnDialog(itemName);
      },
    );
  }

  clickOnDialog(String itemName) {
    switch (itemName) {
      case 'Item':
        navigateToNewItemScreen(Item(''), 'Add Item');
        break;
      case 'Mineral':
        navigateToNewMineralScreen(Mineral('', '0', 0), 'Add Mineral');
        break;
      case 'Unit':
        navigateToNewUnitScreen(Unit(''), 'Add Item');
        break;
    }
  }

  navigateToNewItemScreen(Item item, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddItem(item, title);
    }));
    if (result == true) updateListView();
  }

  navigateToNewMineralScreen(Mineral mineral, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddMineral(mineral, title);
    }));
    if (result == true) updateListView();
  }

  navigateToNewUnitScreen(Unit unit, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddUnit(unit, title);
    }));
    if (result == true) updateListView();
  }
}
