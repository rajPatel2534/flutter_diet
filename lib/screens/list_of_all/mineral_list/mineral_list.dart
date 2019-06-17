import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/models/mineral.dart';
import 'package:login_demo/models/unit.dart';
import 'package:login_demo/screens/add_edit/add_mineral/add_mineral.dart';
import 'package:login_demo/utils/color.dart';
import 'package:login_demo/utils/mineral_database_helper.dart';
import 'package:login_demo/utils/unit_database_helper.dart';

class MineralList extends StatefulWidget {
  MineralList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MineralListState();
  }
}

class MineralListState extends State<MineralList> {
  MineralDatabaseHelper mineralDatabaseHelper = MineralDatabaseHelper();
  UnitDatabaseHelper unitDatabaseHelper = UnitDatabaseHelper();
  List<Mineral> mineralList;
  int count = 0;
  var addThings = ['Mineral', 'Mineral', 'Unit'];
  List<Unit> unitList = List();
  Color themeColor = ColorHelper.themeColor;

  @override
  Widget build(BuildContext context) {
    if (mineralList == null) {
      mineralList = List<Mineral>();
      updateListView();
    }
    return Container(child: getMineralListView());
  }

  ListView getMineralListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: ColorHelper.themeColor,
              child: Icon(Icons.filter_vintage),
            ),
            title: Text(
              this.mineralList[position].name,
              style: textStyle,
            ),
            subtitle: Text(
                '${this.mineralList[position].dailyIntake}  ${this.getUnitById(mineralList[position].unitId)}'),
            trailing: GestureDetector(
                onTap: () {
                  _delete(context, mineralList[position]);
                  updateListView();
                },
                child: Icon(Icons.delete)),
            onTap: () {
              navigateToNextScreen(mineralList[position], 'Edit Mineral');
            },
          ),
        );
      },
    );
  }

  void navigateToNextScreen(Mineral mineral, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddMineral(mineral, title);
    }));
    if (result == true) updateListView();
  }

  Color getPriorityColor(int priority) {
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

  Icon getPriorityIcon(int priority) {
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

  void _delete(BuildContext context, Mineral item) async {
    int result = await mineralDatabaseHelper.deleteMineral(item.id);
    if (result != 0) {
      _showSnackBar(context, 'Mineral Deleted Successfully');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    Future<List<Unit>> unitListFuture = unitDatabaseHelper.getUnitList();
    unitListFuture.then((unitList) {
      setState(() {
        this.unitList = unitList;
      });
    });

    Future<List<Mineral>> itemListFuture =
        mineralDatabaseHelper.getMineralList();
    itemListFuture.then((mineralList) {
      setState(() {
        this.mineralList = mineralList;
        this.count = mineralList.length;
      });
    });
  }

  String getUnitById(int id) {
    Unit unit =
        unitList.firstWhere((unit) => unit.id == id, orElse: () => null);
    debugPrint('$unit $id $unitList');
    if (unit != null) return unit.name;
  }
}
