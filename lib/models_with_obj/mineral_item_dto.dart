import 'package:login_demo/models/item.dart';
import 'package:login_demo/models/mineral.dart';
import 'package:login_demo/models/unit.dart';

class MineralItemWithObj {
  int _id;
  Mineral _mineral;
  Item _item;
  int _quantity;
  Unit _unit;

    MineralItemWithObj.withId(this._id,this._mineral,this._item,this._quantity,this._unit);

  MineralItemWithObj(this._mineral,this._item,this._quantity,this._unit);
  
  int get id => _id;
  Mineral get mineral => _mineral;
  Item get item => _item;
  Unit get unit => _unit;
  int get quantity => _quantity;

  set mineral(Mineral mineral){
    this._mineral = mineral;
  }

  set item(Item item){
    this._item = item;
  }

  set unit(Unit unit){
    this._unit = unit;
  }

  set quantity(int quantity){
    this._quantity = quantity;
  }
  
  }