import 'package:flutter/material.dart';
import 'package:my_f_app/service/app_panels.dart';

class FakeChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FakeChatPageState();
}

class _FakeChatPageState extends State<FakeChatPage> {
  String message;
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    send() {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('You send a message!'),
                content: Text('Your message: ' + message),
                actions: <Widget>[
                  TextButton(
                      child: Text('Ok'),
                      onPressed: () { Navigator.of(context).pop(); }
                  )
                ],
              );
            }
        );
      } else {

      }
    }

    TextStyle textInMessages() {
      return TextStyle(
        fontSize: 16,
        color: Colors.white,
      );
    }

    BoxDecoration messageBoxes() {
      return BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      );
    }

    BoxDecoration avatarBoxes() {
      return BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
      );
    }

   /* final appBar = AppBar(
      title: Text("JoinMe"),
      backgroundColor: Color(0xFF0069C0),
    ); */

    final topPanel = JoinMeAppPanels().getTopPanel(context);

    final bottomPanel = JoinMeAppPanels().getBottomPanel(context);

    final firstMessagesRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.all(5),
          decoration: avatarBoxes(),
          child: ClipOval(
            child: Image.asset('asset/images/chatAva.png'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          width: 250,
          height: 70,
          margin: EdgeInsets.all(5),
          decoration: messageBoxes(),
          child: Text(
            "Mike: We need some water here!",
            style: textInMessages(),
          ),
        ),
      ],
    );

    final secondMessagesRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          width: 250,
          height: 70,
          margin: EdgeInsets.all(5),
          decoration: messageBoxes(),
          child: Text(
            "You: We need some water here!",
            style: textInMessages(),
          ),
        ),
        Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.all(5),
          decoration: avatarBoxes(),
          child: ClipOval(
            child: Image.asset('asset/images/chatAva.png'),
          ),
        ),
      ],
    );

    final thirdMessagesRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.all(5),
          decoration: avatarBoxes(),
          child: ClipOval(
            child: Image.asset('asset/images/chatAva.png'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          width: 250,
          height: 70,
          margin: EdgeInsets.all(5),
          decoration: messageBoxes(),
          child: Text(
            "Lily: We need some water here!",
            style: textInMessages(),
          ),
        ),
      ],
    );

    final fourthMessagesRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.all(5),
          decoration: avatarBoxes(),
          child: ClipOval(
            child: Image.asset('asset/images/chatAva.png'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          width: 250,
          height: 70,
          margin: EdgeInsets.all(5),
          decoration: messageBoxes(),
          child: Text(
            "Jacob: We need some water here!",
            style: textInMessages(),
          ),
        ),
      ],
    );

    final sendMessagesRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          width: 250,
          height: 70,
          margin: EdgeInsets.all(5),
          child: TextFormField(
              autofocus: false,
              validator: (value) => value.isEmpty ? "Write something, please" : null,
              onSaved: (value) => message = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Your message'
              )
          ),
        ),
        Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.all(5),
          child: MaterialButton(
            onPressed: () => send(),
            textColor: Colors.white,
            color: Color(0xFF0069C0),
            child: SizedBox(
              child: Text(
                'Send',
                textAlign: TextAlign.center,
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
      ],
    );

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
                      //appBar,
                      topPanel,
                      SizedBox(height: 10.0),
                      firstMessagesRow,
                      secondMessagesRow,
                      thirdMessagesRow,
                      fourthMessagesRow,
                      sendMessagesRow,
                      SizedBox(height: 10.0),
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