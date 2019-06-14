class MineralItem {
  int _id;
  int _mineralId;
  int _itemId;
  int _itemQuantity;
  int _itemUnitId;
  int _mineralQuantity;
  int _mineralUnitId;

  MineralItem.withId(this._id,this._mineralId,this._itemId,this._itemQuantity,this._itemUnitId,this._mineralQuantity,this._mineralUnitId);

  MineralItem(this._mineralId,this._itemId,this._itemQuantity,this._itemUnitId,this._mineralQuantity,this._mineralUnitId);
  
  int get id => _id;
  int get mineralId => _mineralId;
  int get itemId => _itemId;
  int get itemUnitId => _itemUnitId;
  int get itemQuantity => _itemQuantity;
  int get mineralUnitId => _mineralUnitId;
  int get mineralQuantity => _mineralQuantity;

  set mineralId(int mineralId){
    this._mineralId = mineralId;
  }

  set itemId(int itemId){
    this._itemId = itemId;
  }

  set itemUnitId(int itemUnitId){
    this._itemUnitId = itemUnitId;
  }

  set itemQuantity(int itemQuantity){
    this._itemQuantity = itemQuantity;
  }

  set mineralUnitId(int mineralUnitId){
    this._mineralUnitId = mineralUnitId;
  }

  set mineralQuantity(int mineralQuantity){
    this._mineralQuantity = mineralQuantity;
  }

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();

    if(id != null){
      map['mineral_item_id'] = _id;
    }
    map['item_unit_id'] = _itemUnitId;
    map['item_quantity'] = _itemQuantity;
    map['mineral_unit_id'] = _mineralUnitId;
    map['mineral_quantity'] = _mineralQuantity;
    map['item_id'] = _itemId;
    map['mineral_id'] = _mineralId;
    return map;
  }

  MineralItem.fromMapObject(Map<String, dynamic> map){
    this._id = map['mineral_item_id'];
    this._mineralId = map['mineral_id'];
    this._itemId = map['item_id'];
    this._itemUnitId = map['item_unit_id'];
    this._itemQuantity = map['item_quantity'];
    this._mineralUnitId = map['mineral_unit_id'];
    this._mineralQuantity = map['mineral_quantity'];
  }

}
