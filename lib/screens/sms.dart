import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:notes/screens/notification.dart';

class Message extends StatefulWidget {
  final String _name;
  final String _number;

  Message(this._name, this._number);

  @override
  MessageState createState() => MessageState(_name, _number);
}

class MessageState extends State<Message> {
  String _name;
  String _number;

  MessageState(this._name, this._number);

  TextEditingController txtController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Сообщение'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.send),
              tooltip: 'Отправить сообщение',
              onPressed: () {
                sendSMS(_number);
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Получатель: '),
                  Chip(
                    label: Text('$_name ($_number)'),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.black87,
                      radius: 25.0,
                      child: Text(
                        _name.length > 1 ? _name?.substring(0, 1) : "",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: TextFormField(
                  controller: txtController,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Текст сообщения',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ));
  }

  void sendSMS(String number) {
    SmsSender sender = new SmsSender();
    if (txtController.text.length > 0) {
      SmsMessage msg = new SmsMessage(number, txtController.text);
      msg.onStateChanged.listen((state) {

        if (state == SmsMessageState.Sent) {
          Notifier.notify('Сообщение отослано', 'Ожидайте подтверждения доставки');
        } else if (state == SmsMessageState.Delivered) {
          Notifier.notify('Сообщение доставлено', 'При доставке не пострадал ни один конверт');
        } else if (state == SmsMessageState.Fail) {
          Notifier.notify('Возникла ошибка', 'Что-то пошло не так при доставке сообщения');
        }

      });

      sender.sendSms(msg);
      Navigator.pop(context, true);

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Пустое сообщение'),
            content: const Text(
                'Пустые сообщения вслед за пустыми заметками? Ну и как это называется?'),
            actions: <Widget>[
              FlatButton(
                splashColor: Colors.black12,
                highlightColor: Colors.black12,
                child: Text('Ой...', style: TextStyle(color: Colors.black)),
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
