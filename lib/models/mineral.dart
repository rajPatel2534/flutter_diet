class Mineral {
  int _id;
  String _name;
  String _dailyIntake;
  int _unitId;


  Mineral.withId(this._id,this._name,this._dailyIntake,this._unitId);

  Mineral(this._name,this._dailyIntake,this._unitId);
  
  int get id => _id;
  String get name => _name;
  String get dailyIntake => _dailyIntake;
  int get unitId => _unitId;

  set name(String name){
    this._name = name;
  }

  set dailyIntake(String dailyIntake){
    this._dailyIntake = dailyIntake;
  }

  set unitId(int unitId){
    this._unitId = unitId;
  }

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();

    if(id != null){
      map['mineral_id'] = _id;
    }
    map['mineral_name'] = _name;
    map['daily_intake'] = _dailyIntake;
    map['unit'] = _unitId;
    return map;
  }

  Mineral.fromMapObject(Map<String, dynamic> map){
    this._id = map['mineral_id'];
    this._name = map['mineral_name'];
    this._dailyIntake = map['daily_intake'];
    this._unitId = map['unit'];
  }

}
