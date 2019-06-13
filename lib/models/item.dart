class Item {
  int _id;
  String _name;

  Item.withId(this._id,this._name);

  Item(this._name);
  
  int get id => _id;
  String get name => _name;

  set name(String name){
    this._name = name;
  }

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();

    if(id != null){
      map['item_id'] = _id;
    }
    map['item_name'] = _name;
    return map;
  }

  Item.fromMapObject(Map<String, dynamic> map){
    this._id = map['item_id'];
    this._name = map['item_name'];
  }

}
