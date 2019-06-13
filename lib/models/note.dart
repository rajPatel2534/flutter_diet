class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note.withId(this._id,this._title,this._date,this._priority,[this._description]);

  Note(this._title,this._date,this._priority,[this._description]);
  
  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  set title(String newTitle){
    this._title = newTitle;
  }

  set description(String description){
    this._description = description;
  }

  set priority(int priority){
    this._priority = priority;
  }

  set date(String date){
    this._date = date;
  }

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();

    if(id != null){
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }

}
