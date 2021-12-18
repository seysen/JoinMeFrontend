import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_f_app/domain/user.dart';
import 'package:my_f_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_f_app/service/app_panels.dart';

class ProfilePage extends StatefulWidget{
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum ProfileTabs {
  About,
  Photo,
  Events
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileTabs _currentTab = ProfileTabs.About;

  var _isFABVisible = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    final profileImage = Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage('asset/images/chatAva.png') //Change to profile.image
            )
        )
    );

    final profileName = Container(
      padding: new EdgeInsets.only(right: 13.0),
        child: Text(
          user.name.toString() + " " + user.surname.toString(),
          overflow: TextOverflow.ellipsis,
          style:  TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
        )
    );

    final profilePanel = Container(
        height: 200,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: profileImage,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: profileName,
                  )
                ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.assignment_ind_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFABVisible = false;
                        _currentTab = ProfileTabs.About;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '|',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 40,
                        letterSpacing: 0.5,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFABVisible = false;
                        _currentTab = ProfileTabs.Photo;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '|',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 40,
                        letterSpacing: 0.5,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.format_list_bulleted_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFABVisible = true;
                        _currentTab = ProfileTabs.Events;
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Color(0xFF0069C0)
        )
    );

    Widget ProfileAbout = Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("About me..."),
      ),
    );

    Widget ProfitePhotos = Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Photos"),
      ),
    );

    Widget ProfileEvets = Center(
        child:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Events"),
        ),
        // ListView.builder(
        //     itemBuilder: (BuildContext context, int index) {
        //       return Container(
        //           child: Row(
        //             children: [
        //               Container(
        //                   width: 80.0,
        //                   height: 80.0,
        //                   decoration: BoxDecoration(
        //                       shape: BoxShape.circle,
        //                       image: DecorationImage(
        //                           fit: BoxFit.fill,
        //                           image: new AssetImage('asset/images/chatAva.png') //Change to profile.image
        //                       )
        //                   )
        //               ),
        //               Column(
        //                 children: [
        //                   Text("Event name"),
        //                   Text("Event date")
        //                 ],
        //               )
        //             ],
        //           ),
        //           decoration: BoxDecoration(
        //             color: Colors.blueAccent,
        //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //           )
        //       );
        //     }
        // )
    );

    Widget currentProfilePage() {
      switch(_currentTab){
        case ProfileTabs.Events:
          return ProfileEvets;
          break;
        case ProfileTabs.Photo:
          return ProfitePhotos;
        case ProfileTabs.About:
        default:
          return ProfileAbout;
      }
    }

    final bottomPanel = JoinMeAppPanels().getBottomPanel(context);

    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  profilePanel,
                  currentProfilePage(),
                ],
              ),
              Positioned(
                bottom: 75,
                right: 15,
                child: Visibility(
                  visible: _isFABVisible,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/events');
                    },
                    backgroundColor: Color(0xFF0069C0),
                    child: const Icon(Icons.add),
                  ),
                ),
              )
            ],
          ),
          bottomSheet: bottomPanel,
        )
    );
  }
}


