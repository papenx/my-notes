

class NoteModel {

  // fields
  int _id;
  String _text;
  String _date;

  // constructors
  NoteModel(this._text, this._date);
  NoteModel.withID(this._id, this._text, this._date);

  //  getters
  int get id => _id;
  String get text => _text;
  String get date => _date;

  // setters
  set text(String value){
    if(value.length > 0){
      _text = value;
    }
  }

  set date(String value){
    if(value.length > 0){
      _date = value;
    }
  }

  Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map["text"] = _text;
    map["date"] = _date;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  NoteModel.fromObject(dynamic o){
    this._id = o["ID"];
    this._text = o["Text"];
    this._date = o["Date"];
  }

}