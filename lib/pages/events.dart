import 'package:flutter/material.dart';

import 'package:my_f_app/domain/event.dart';
import 'package:my_f_app/domain/user.dart';
import 'package:my_f_app/providers/event_provider.dart';
import 'package:my_f_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final formKey = new GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final photoTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  String _eventName, _description, _linkAva;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    EventProvider eventProvider = Provider.of<EventProvider>(context);

    create() {
      final form = formKey.currentState;
      if(form.validate()) {
        form.save();
        eventProvider.create(_eventName, _description, _linkAva, user.id).then((response) {
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
                          onPressed: () { Navigator.pushReplacementNamed(context, '/dashboard'); }
                      )
                    ],
                  );
                }
            );

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
                      onPressed: () { Navigator.of(context).pop(); }
                    )
                  ],
                );
              }
            );
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
                      onPressed: () { Navigator.of(context).pop(); }
                  )
                ],
              );
            }
        );
      }
    }

    cancel() {
      nameTextController.clear();
      photoTextController.clear();
      descriptionTextController.clear();
    }

    uploadImage() {
      //todo selecting and uploading event ava
    }

    final eventNameField = TextFormField(
      controller: nameTextController,
      autofocus: false,
      validator: (value) => value.isEmpty ? "Please fill name of event" : null,
      onSaved: (value) => _eventName = value,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        hintText: 'Name of new Event'
      )
    );

    /* For future form with date of event
    final eventDateField = TextFormField(
        controller: dateTextController,
        autofocus: false,
        onSaved: (value) => _eventTags = value,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            hintText: 'Date of new Event'
        )
    ); */

    /* For future form with tags
    final eventTagsField = TextFormField(
        controller: tagsTextController,
        autofocus: false,
        onSaved: (value) => _eventName = value,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            hintText: 'Tags for new Event'
        )
    ); */

    final eventAvaField = Container(
      width: 80,
      height: 80,
      child: TextFormField(
          controller: photoTextController,
          autofocus: false,
          expands: true,
          minLines: null,
          maxLines: null,
          onSaved: (value) => _linkAva = value,
          decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              hintText: 'Photo'
          )
    )
    );

    final eventDescriptionField = Container(
        width: 500,
        height: 150,
        child: TextFormField(
            controller: descriptionTextController,
            autofocus: false,
            expands: true,
            minLines: null,
            maxLines: null,
            onSaved: (value) => _description = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                hintText: 'Description for new event'
            )
        )
    );

    final workWithAva = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 8.0, 8.0, 8.0),
            child: eventAvaField,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 32.0, 8.0),
          child: MaterialButton(
            onPressed: () => uploadImage(),
            textColor: Colors.white,
            color: Color(0xFF0069C0),
            child: SizedBox(
              width: 50,
              child: Text(
                'Upload',
                textAlign: TextAlign.center,
              ),
            ),
            height: 30,
            minWidth: 50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
      ],
    );

    final logo = Image.asset(
      'asset/images/JoinMeLogo.png',
    );

    //HERE HOW IT VIEWED
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(40.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 5.0,),
                      logo,
                      SizedBox(height: 10.0,),
                      eventNameField,
                      /*
                      SizedBox(height: 20.0,),
                      eventDateField,
                      SizedBox(height: 20.0,),
                      eventTagsField,
                       */
                      SizedBox(height: 10.0,),
                      workWithAva,
                      SizedBox(height: 10.0,),
                      eventDescriptionField,
                      saveButtonsRow,
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}