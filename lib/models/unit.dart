class Unit {
  int _id;
  String _name;

  Unit.withId(this._id,this._name);

  Unit(this._name);
  
  int get id => _id;
  String get name => _name;
  
  set name(String name){
    this._name = name;
  }

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();

    if(id != null){
      map['unit_id'] = _id;
    }
    map['unit_name'] = _name;
    return map;
  }

  Unit.fromMapObject(Map<String, dynamic> map){
    this._id = map['unit_id'];
    this._name = map['unit_name'];
  }

}
