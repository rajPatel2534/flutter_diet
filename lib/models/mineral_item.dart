class MineralItem {
  int _id;
  int _mineralId;
  int _itemId;
  int _quantity;
  int _unitId;

  MineralItem.withId(this._id,this._mineralId,this._itemId,this._quantity,this._unitId);

  MineralItem(this._mineralId,this._itemId,this._quantity,this._unitId);
  
  int get id => _id;
  int get mineralId => _mineralId;
  int get itemId => _itemId;
  int get unitId => _unitId;
  int get quantity => _quantity;

  set mineralId(int mineralId){
    this._mineralId = mineralId;
  }

  set itemId(int itemId){
    this._itemId = itemId;
  }

  set unitId(int unitId){
    this._unitId = unitId;
  }

  set quantity(int quantity){
    this._quantity = quantity;
  }

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();

    if(id != null){
      map['mineral_item_id'] = _id;
    }
    map['unit_id'] = _unitId;
    map['item_id'] = _itemId;
    map['mineral_id'] = _mineralId;
    map['quantity'] = _quantity;
    return map;
  }

  MineralItem.fromMapObject(Map<String, dynamic> map){
    this._id = map['mineral_item_id'];
    this._mineralId = map['mineral_id'];
    this._itemId = map['item_id'];
    this._unitId = map['unit_id'];
    this._quantity = map['quantity'];
  }

}
