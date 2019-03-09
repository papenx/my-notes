import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/db/db.dart';
import 'package:date_format/date_format.dart';

class Add extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddState();
}

class _AddState extends State<Add> {

  TextEditingController txtController = new TextEditingController();
  DB db = new DB();
  String createDate = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' в ', HH, ':', nn]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Новая заметка"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'Сохранить заметку',
            onPressed: (){
              save();
            },
          )
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
              '$createDate',
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

  void save() async {
    if (txtController.text.length > 0) {
      int result = await db.insert(NoteModel(txtController.text, createDate));
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
                    'ОК',
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