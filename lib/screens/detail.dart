import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/db/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_format/date_format.dart';

class Detail extends StatefulWidget{

  final NoteModel myNote;
  Detail(this.myNote);

  @override
  State<StatefulWidget> createState() => _DetailState(myNote);
}


class _DetailState extends State<Detail> {
  NoteModel myNote;
  _DetailState(this.myNote);


  TextEditingController txtController = new TextEditingController();
  DB db = new DB();
  String createDate = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' в ', HH, ':', nn]);


  @override
  Widget build(BuildContext context) {

    txtController.text = myNote.text;
    txtController.selection = new TextSelection(
        baseOffset:  myNote.text.length,
        extentOffset: myNote.text.length
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Подробности"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Удалить заметку',
            onPressed: () {
              delete(myNote.id);
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'Сохранить заметку',
            onPressed: (){
              NoteModel updateNote = NoteModel.fromObject({"ID": myNote.id, "Text": txtController.text, "Date": createDate});
              update(updateNote);
            },
          ),
        ],
      ),
      body: editForm(),
    );
  }

  Container editForm() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Opacity(
            opacity: 0.7,
            child: Text(
              '${myNote.date}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.0,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: txtController,
              style: TextStyle(
                fontSize: 20.0,
              ),
              decoration: const InputDecoration(
                hintText: 'Хочу не забыть...',
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          )
        ],
      ),
    );
  }

  void delete(id) async {
    int result = await db.delete(id);
    if (result != 0) {
      Navigator.pop(context, true);
    }
  }

  void update(NoteModel note) async{

    if (txtController.text.length > 0) {
      int result = await db.update(note);
      if (result != 0) {
        Navigator.pop(context, true);
      }
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Вы ничего не записали'),
            content: const Text('Пустые заметки - мусор, с которым необходимо бороться наиболее радикальными методами, такими как этот.'),
            actions: <Widget>[
              FlatButton(
                splashColor: Colors.black12,
                highlightColor: Colors.black12,
                child: Text(
                    'Хорошо',
                    style: TextStyle(
                        color: Colors.black
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }



}