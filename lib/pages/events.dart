import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:my_f_app/domain/user.dart';
import 'package:my_f_app/providers/event_provider.dart';
import 'package:my_f_app/providers/user_provider.dart';
import 'package:my_f_app/service/app_panels.dart';
import 'package:my_f_app/util/validators.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final formKey = new GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final dateTextController = TextEditingController();

  String _eventName, _description, _linkAva, _eventDate;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    EventProvider eventProvider = Provider.of<EventProvider>(context);

    create() {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        eventProvider
            .create(_eventName, _description, _linkAva, user.id, _eventDate)
            .then((response) {
          if (response['status']) {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(response['message']),
                    content: Text('New event ID: ' + response['data']),
                    actions: <Widget>[
                      TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/fake_chat');
                          })
                    ],
                  );
                });
          } else {
            return showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Event creation failed'),
                    content: Text(response.toString()),
                    actions: <Widget>[
                      TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  );
                });
          }
        });
      } else {
        return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Invalid form'),
                content: Text('Fill the form correctly, please.'),
                actions: <Widget>[
                  TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    }

    cancel() {
      nameTextController.clear();
      descriptionTextController.clear();
      dateTextController.clear();
      Navigator.pushReplacementNamed(context, '/profile_page');
    }

    postImageToAWS(String imageFilePath) async {
      eventProvider
          .getAvatarLinkFromAWS(File(imageFilePath))
          .then((response) {
        if (response['status']) {
          _linkAva = response['data'];
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(response['message']),
                  content: Image.file(
                    File(imageFilePath),
                    fit: BoxFit.fitWidth,
                    width: 150,
                    height: 150,
                  ),
                  actions: <Widget>[
                    TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        } else {
          return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(response['message']),
                  content: Text(response['data']),
                  actions: <Widget>[
                    TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        }
      });
    }

    uploadImage() async {
      FilePickerResult fileFromFilePicker = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if(fileFromFilePicker != null) {
        String imageFilePath = fileFromFilePicker.files.single.path;
        int imageSize = File(imageFilePath).lengthSync();

        if (imageSize/1048576 < 3 ) {
          postImageToAWS(imageFilePath);
        } else {
          fileFromFilePicker == null;
          return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Your image too big'),
                  content: Text('Your image should be less then 3 MB'),
                  actions: <Widget>[
                    TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        }
      } else {
        //user canceled file picker
        return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('You canceled uploading'),
                content: Text('Image uploading canceled'),
                actions: <Widget>[
                  TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    }

    final eventNameField = TextFormField(
        controller: nameTextController,
        autofocus: false,
        validator: (value) =>
            value.isEmpty ? "Please fill name of event" : null,
        onSaved: (value) => _eventName = value,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            hintText: 'Name of new Event'));

    final eventDateField = TextFormField(
        controller: dateTextController,
        autofocus: false,
        validator: validateEventDate,
        onSaved: (value) => _eventDate = value,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            hintText: 'Date of new Event'
        )
    );


    final eventDescriptionField = Container(
        width: 500,
        height: 100,
        child: TextFormField(
            controller: descriptionTextController,
            autofocus: false,
            expands: true,
            minLines: null,
            maxLines: null,
            onSaved: (value) => _description = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                hintText: 'Description for new event')));

    final workWithAva = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () => uploadImage(),
            textColor: Colors.white,
            color: Color(0xFF0069C0),
            child: SizedBox(
              width: 150,
              child: Text(
                'Upload image for event',
                textAlign: TextAlign.center,
              ),
            ),
            height: 40,
            minWidth: 150,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
      ],
    );

    final saveButtonsRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 8.0, 8.0, 8.0),
          child: MaterialButton(
            onPressed: () => create(),
            textColor: Colors.white,
            color: Color(0xFF0069C0),
            child: SizedBox(
              width: 50,
              child: Text(
                'Done',
                textAlign: TextAlign.center,
              ),
            ),
            height: 30,
            minWidth: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 32.0, 8.0),
          child: MaterialButton(
            onPressed: () => cancel(),
            textColor: Colors.white,
            color: Color(0xFF0069C0),
            child: SizedBox(
              width: 50,
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
              ),
            ),
            height: 30,
            minWidth: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
      ],
    );

    final logo = SizedBox(
        width: 88,
        height: 70,
        child: Image.asset(
          'asset/images/JoinMeLogo.png',
        )
    );

    final bottomPanel = JoinMeAppPanels().getBottomPanel(context);

    //HERE HOW IT VIEWED
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 5.0),
                      logo,
                      SizedBox(height: 5.0),
                      eventNameField,
                      SizedBox(height: 5.0,),
                      eventDateField,
                      SizedBox(height: 5.0),
                      workWithAva,
                      SizedBox(height: 5.0),
                      eventDescriptionField,
                      saveButtonsRow
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomSheet: bottomPanel,
      )
    );
  }
}
