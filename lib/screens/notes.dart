import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes/db/db.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/detail.dart';
import 'package:notes/screens/add.dart';
import 'package:notes/screens/notification.dart';
import 'package:notes/screens/contacts.dart';
import 'package:notes/screens/mail.dart';


class Notes extends StatefulWidget {
  @override
  NoteState createState() => new NoteState();
}

class NoteState extends State<Notes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  DB db = new DB();
  List<NoteModel> myNotesList;
  bool noData = true;
  bool enabledNotifications = false;

  @override
  Widget build(BuildContext context) {
    if (myNotesList == null) {
      myNotesList = new List<NoteModel>();

      getData();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Мои заметки',
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Меню',
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Добавить заметку',
            onPressed: () {
              goToAdd();
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text(
                  'Привет.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              padding: EdgeInsets.all(20.0),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Написать сообщение'),
              onTap: () {
                // Update the state of the app
                // ...
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => ContactListPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.send),
              title: Text('Отправить БД'),
              onTap: () {
                // Update the state of the app
                Navigator.push(context, CupertinoPageRoute(builder: (context) => Mail()));
              },
            ),
            ListTile(
              enabled: !noData,
              leading: Icon(Icons.delete_sweep),
              title: Text('Удалить все заметки'),
              onTap: () {
                // Update the state of the app
                deleteAllNotes();
              },
            ),
          ],
        ),
      ),
      body: listNotes(),
    );
  }

  dynamic listNotes() {
    if (!noData) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15.0),
        itemCount: myNotesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              goToDetail(this.myNotesList[index]);
            },
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(4.0),
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.0, 1.0],
                    colors: [
                      const Color(0xff2b5876),
                      const Color(0xff4e4376),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${myNotesList[index].text}',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                      child: Opacity(
                        opacity: 0.7,
                        child: Text('${myNotesList[index].date}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: 0.85,
              child: Text(
                'Ваш список заметок пуст',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  'Не держи всё в голове, используй для этого память телефона',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.note_add),
              onPressed: () {
                goToAdd();
              },
              iconSize: 35.0,
              tooltip: 'Добавьте первую заметку',
            ),
          ],
        ),
      );
    }
  }

  void getData() {
    var dbFuture = db.initializeDb();
    dbFuture.then((result) {
      var notesFuture = db.getNotes();
      notesFuture.then((data) {

        List<NoteModel> notesData = new List<NoteModel>();

        for (var i = 0; i < data.length; i++) {
          notesData.add(NoteModel.fromObject(data[i]));
        }

        setState(() {
          myNotesList = notesData;
          noData = myNotesList.length == 0;
          enabledNotifications = myNotesList.length == 0;
        });
      });
    });
  }

  void goToDetail(NoteModel myNote) async {
    bool result = await Navigator.push(
        context, CupertinoPageRoute(builder: (context) => Detail(myNote)));
    if (result != null && result) {
      getData();
    } else {
      print('Error in navigatin to Detai page');
    }
  }

  void goToAdd() async {
    bool result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => Add()));
    if (result != null && result) {
      getData();
      if (enabledNotifications) Notifier.notify('Первый блин всегда комом!', 'Ура! Вы добавили свою первую заметку');
    } else {
      print('Error in navigating to Add page');
    }
  }

  void deleteAllNotes() async {
    int result = await db.deleteAllNotes();
    if (result != 0) {
      Navigator.pop(context);
      getData();
    } else {
      print('Delete All Notes error');
    }
  }
}
