import 'package:login_demo/models/item.dart';
import 'package:login_demo/models/mineral.dart';
import 'package:login_demo/models/unit.dart';

class MineralItemWithObj {
  int _id;
  Mineral _mineral;
  Item _item;
  int _itemQuantity;
  Unit _itemUnit;
  int _mineralQuantity;
  Unit _mineralUnit;

  MineralItemWithObj.withId(this._id,this._mineral,this._item,this._itemQuantity,this._itemUnit,this._mineralQuantity,this._mineralUnit);

  MineralItemWithObj(this._mineral,this._item,this._itemQuantity,this._itemUnit,this._mineralQuantity,this._mineralUnit);
  
  int get id => _id;
  Mineral get mineral => _mineral;
  Item get item => _item;
  Unit get itemUnit => _itemUnit;
  int get itemQuantity => _itemQuantity;
  Unit get mineralUnit => _mineralUnit;
  int get mineralQuantity => _mineralQuantity;

  set mineral(Mineral mineral){
    this._mineral = mineral;
  }

  set item(Item item){
    this._item = item;
  }

  set itemUnit(Unit itemUnit){
    this._itemUnit = itemUnit;
  }

  set itemQuantity(int itemQuantity){
    this._itemQuantity = itemQuantity;
  }

  set mineralUnit(Unit mineralUnit){
    this._mineralUnit = mineralUnit;
  }

  set mineralQuantity(int mineralQuantity){
    this._mineralQuantity = mineralQuantity;
  }
  
  }