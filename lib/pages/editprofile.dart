import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/Widgets/progress.dart';
import 'home.dart';
import 'Models/users.dart';

class EditProfile extends StatefulWidget {
  final String currentuserId;
  EditProfile({this.currentuserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  bool isloading = false;
  User user;
  bool _displayNamevalid = true;
  bool _bioValid = true;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isloading = true;
    });
    DocumentSnapshot doc = await userref.document(widget.currentuserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayname;
    bioController.text = user.bio;
    setState(() {
      isloading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Display Name",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
              hintText: "Update Display name..",
              errorText: _displayNamevalid ? null : "Display name too short",
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 15.0,
              )),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio..",
            errorText: _bioValid ? null : "Bio too long",
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 15.0,
            ),
          ),
        )
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNamevalid = false
          : _displayNamevalid = true;
      bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });
    if (_displayNamevalid && _bioValid) {
      userref.document(widget.currentuserId).updateData({
        "displayname": displayNameController.text,
        "bio": bioController.text,
      });
      SnackBar snackbar = SnackBar(
        content: Text("Profile updated"),
      );
      _scaffoldkey.currentState.showSnackBar(snackbar);
    }
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent[100],
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Signatra",
            fontSize: 30.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.done,
                size: 30.0,
                color: Colors.green,
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: isloading
          ? CircularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 8.0),
                        child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                CachedNetworkImageProvider(user.photourl)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: updateProfileData,
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        color: Colors.deepOrangeAccent[100],
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: RaisedButton(
                          onPressed: logout,
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          color: Colors.deepOrangeAccent[100],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
