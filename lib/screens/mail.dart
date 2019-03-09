import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class Mail extends StatefulWidget {
  @override
  MailState createState() => new MailState();
}

class MailState extends State<Mail> {
  String _path = '';
  TextEditingController txtControllerMail = new TextEditingController();
  TextEditingController txtControllerTopic = new TextEditingController();
  TextEditingController txtControllerBody = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отправить письмо'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              getFilePath();
            },
            icon: Icon(Icons.attachment),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              sendMail();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtControllerMail,
              style: TextStyle(
                fontSize: 18.0,
              ),
              decoration: const InputDecoration(
                hintText: 'Email получателя',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextFormField(
              controller: txtControllerTopic,
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontSize: 18.0,
              ),
              decoration: const InputDecoration(
                hintText: 'Тема',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextFormField(
              maxLines: 3,
              controller: txtControllerBody,
              style: TextStyle(
                fontSize: 18.0,
              ),
              decoration: const InputDecoration(
                hintText: 'Текст',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            Text(
              'Прикрепленный файл',
              style: TextStyle(
                color: const Color(0xFFb2b2b2),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              _path != '' ? _path.split('/').last : 'Вы пока что ничего не прикрепили.',
              style: TextStyle(fontSize: 18.0),
            )
          ],
        ),
      ),
    );
  }

  void getFilePath() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.ANY);
      if (filePath == '') {
        return;
      }
      setState(() {
        this._path = filePath;
      });
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  void sendMail() async {

    if (validateEmail(txtControllerMail.text)) {

      final Email email = Email(
        body: txtControllerBody.text,
        subject: txtControllerTopic.text,
        recipients: [txtControllerMail.text],
        attachmentPath: _path != '' ? _path : null,
      );

      await FlutterEmailSender.send(email);

    } else {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Невалидный почтовый адрес'),
            content: const Text('Наша регулярка считает, что вы ввели неправильный email.'),
            actions: <Widget>[
              FlatButton(
                splashColor: Colors.black12,
                highlightColor: Colors.black12,
                child: Text(
                    'Действительно',
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


  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(value))
      return true;
    else
      return false;
  }
}
