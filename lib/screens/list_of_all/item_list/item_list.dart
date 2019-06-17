import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/models/item.dart';
import 'package:login_demo/models_with_obj/mineral_item_dto.dart';
import 'package:login_demo/screens/add_edit/add_item/add_item.dart';
import 'package:login_demo/screens/add_edit/add_mineral_item/add_mineral_item.dart';
import 'package:login_demo/utils/color.dart';
import 'package:login_demo/utils/item_database_helper.dart';
import 'package:login_demo/utils/mineral_item_database_helper.dart';

class ItemList extends StatefulWidget {
  ItemList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ItemListState();
  }
}

class _ItemWithMineralDetail {
  Item item;
  List<MineralItemWithObj> listOfMineralItemWithObj;

  _ItemWithMineralDetail(this.item, this.listOfMineralItemWithObj);
}

class ItemListState extends State<ItemList>
    with SingleTickerProviderStateMixin {
  ItemDatabaseHelper itemDatabaseHelper = ItemDatabaseHelper();
  MineralItemDatabaseHelper mineralItemDatabaseHelper =
      MineralItemDatabaseHelper();
  List<Item> itemList;
  List<_ItemWithMineralDetail> itemListWithMinerals =
      List<_ItemWithMineralDetail>();
  int count = 0;
  var addThings = ['Item', 'Mineral', 'Item'];
  List<bool> detailOpenList = List<bool>();
  bool isDataLoading = true;
  Color themeColor = ColorHelper.themeColor;

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Item>();
      updateListView();
    }
    return (isDataLoading == true)
        ? Center(
            child: CircularProgressIndicator(
              // backgroundColor: Colors.red,
              valueColor: AlwaysStoppedAnimation<Color>(ColorHelper.themeColor),
            ),
          )
        : Container(child: getItemListView());
  }

  ListView getItemListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
            color: Colors.white,
            elevation: 4.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: ColorHelper.themeColor,
                child: Icon(Icons.insert_chart),
              ),
              // title: Text(
              //   this.itemList[position].name,
              //   style: TextStyle(
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.w600
              //   ),

              // ),
              title: Container(
                  // transform: Matrix4.translationValues(-15.0, 5.0, 0.0),

                  child: ExpansionTile(
                title: GestureDetector(
                  child: Container(
                    // margin: EdgeInsets.only(left: -10.0),
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Text(this.itemList[position].name,
                        style: TextStyle(
                            fontSize: 16.0,
                            // fontWeight: FontWeight.w600,
                            color: (this.detailOpenList[position] == false)
                                ? Colors.black
                                : ColorHelper.themeColor)),
                  ),
                  onTap: () {
                    navigateToAddMineralItemScreen(
                        itemList[position], 'Edit Item');
                  },
                ),
                children: <Widget>[
                  // Column(
                  //   children: <Widget>[
                  (this
                              .itemListWithMinerals[position]
                              .listOfMineralItemWithObj
                              .length ==
                          0)
                      ? Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text('No Records Available !'))
                      : getSubtitleListViewOfMineralOfItem(
                          this.itemListWithMinerals[position])
                ],
                trailing: (this.detailOpenList[position] == false)
                    ? Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      )
                    : Icon(
                        Icons.keyboard_arrow_up,
                        color: ColorHelper.themeColor,
                      ),
                onExpansionChanged: (isExpanded) {
                  setState(() {
                    this.detailOpenList[position] = isExpanded;
                  });
                },
              ))

              //              AnimatedSize(
              //               duration: Duration(milliseconds: 120),
              //                 vsync: this,
              // curve: Curves.fastOutSlowIn,

              //               // margin: EdgeInsets.only(top: 5.0),
              //              child :
              //   (detailOpenList[position] == false) ?
              // GestureDetector(
              // child : Text('Open Details'),
              // onTap: (){
              //   setState(() {
              //   detailOpenList[position]  = true;
              //   });
              // },
              // )
              // :
              ,
              trailing: GestureDetector(
                  onTap: () {
                    _delete(context, itemList[position]);
                    updateListView();
                  },
                  child: Icon(Icons.delete)),
              onTap: () {
                navigateToAddMineralItemScreen(itemList[position], 'Edit Item');
              },
            ));
      },
    );
  }

  ListView getSubtitleListViewOfMineralOfItem(_ItemWithMineralDetail item) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: item.listOfMineralItemWithObj.length,
        itemBuilder: (BuildContext context, int position) {
          return Container(
              // padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 1.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Text(
                          '${item.listOfMineralItemWithObj[position].itemQuantity}')),
                  Expanded(
                    child: Text(
                        '${item.listOfMineralItemWithObj[position].itemUnit.name}'),
                  ),
                  Expanded(
                    child: Text(
                      '${item.listOfMineralItemWithObj[position].mineral.name}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${item.listOfMineralItemWithObj[position].mineralQuantity}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${item.listOfMineralItemWithObj[position].mineralUnit.name}',
                      textAlign: TextAlign.center,
                    ),
                  )
                  // Text('${item.listOfMineralItemWithObj[position].itemUnit.name}')
                  // ,
                  //   Text('${item.listOfMineralItemWithObj[position].mineral.name}')
                  // ,

                  //   Text('${item.listOfMineralItemWithObj[position].mineralQuantity}')
                  // ,
                  //  Text('${item.listOfMineralItemWithObj[position].mineralUnit.name}')
                ],
              ));
        });
  }

  void navigateToNextScreen(Item item, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddItem(item, title);
    }));
    if (result == true) updateListView();
  }

  void navigateToAddMineralItemScreen(Item item, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddMineralItem(item, title);
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

  void _delete(BuildContext context, Item item) async {
    int result = await itemDatabaseHelper.deleteItem(item.id);
    if (result != 0) {
      _showSnackBar(context, 'Item Deleted Successfully');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() async {
    Future<List<Item>> itemListFuture = itemDatabaseHelper.getItemList();
    itemListFuture.then((itemList) async {
      // setState(() async {
      this.itemList = itemList;
      this.count = itemList.length;
      for (int i = 0; i < this.count; i++) {
        this.detailOpenList.add(false);
        this.itemListWithMinerals.add(_ItemWithMineralDetail(
            this.itemList[i],
            await mineralItemDatabaseHelper
                .getMineralItemListWithObj(this.itemList[i].id)));
      }
      isDataLoading = false;
      setState(() {});
    });
  }
}
