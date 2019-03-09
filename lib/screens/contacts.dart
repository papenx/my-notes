import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:notes/screens/sms.dart';
import 'package:flutter/cupertino.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  Iterable<Contact> _contacts;

  @override
  initState() {
    super.initState();
    refreshContacts();
  }

  refreshContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var contacts = await ContactsService.getContacts();
      contacts =
          contacts.where((i) => i.displayName != null && i.phones.length > 0);
      setState(() {
        _contacts = contacts;
      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Выберите контакт')),
      body: _contacts != null
          ? ListView.separated(
              padding: EdgeInsets.all(15.0),
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) => Divider(
                    color: const Color(0xFFe1e1e1),
                  ),
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact c = _contacts?.elementAt(index);
                return ListTile(
                  title: Text(c.displayName),
                  subtitle: Text('${c.phones.map((i) => i.value).join(', ')}'),
                  onTap: () {
                    // берем первый номер из всех имеющихся
                    var phoneNumber = c.phones.toList()[0].value;
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (context) => Message(c.displayName, phoneNumber)));
                  },
                  leading: (c.avatar != null && c.avatar.length > 0)
                      ? CircleAvatar(
                          radius: 25.0,
                          backgroundImage: MemoryImage(c.avatar),
                        )
                      : CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.black87,
                          child: Text(
                            c.displayName.length > 1
                                ? c.displayName?.substring(0, 1)
                                : "",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

