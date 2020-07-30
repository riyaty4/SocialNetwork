import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/Widgets/progress.dart';
import 'package:social_app/pages/Timeline.dart';

import 'Models/users.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchcontroller = TextEditingController();
  Future<QuerySnapshot> searchresultfuture;

  handlesearch(String query) {
    Future<QuerySnapshot> users =
        userref.where("username", isGreaterThanOrEqualTo: query).getDocuments();
    setState(() {
      searchresultfuture = users;
    });
  }

  clearsearch() {
    searchcontroller.clear();
  }

  buildsearchfield() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchcontroller,
        decoration: InputDecoration(
          hintText: "Search for User...",
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearsearch,
          ),
        ),
        onFieldSubmitted: handlesearch,
      ),
    );
  }

  buildnocontent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
          child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/search.svg',
            height: orientation == Orientation.portrait ? 300.0 : 200.0,
          ),
          Text("Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
                fontFamily: "Signatra",
              ))
        ],
      )),
    );
  }

  buildserachresult() {
    return FutureBuilder(
      future: searchresultfuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgress();
        }

        List<Userresult> searchresults = [];
        snapshot.data.documents.forEach((DocumentSnapshot doc) {
          User user = User.fromDocument(doc);
          Userresult searchresult = Userresult(user);
          searchresults.add(searchresult);
        });
        return ListView(
          children: searchresults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      appBar: buildsearchfield(),
      body: searchresultfuture == null ? buildnocontent() : buildserachresult(),
    );
  }
}

class Userresult extends StatelessWidget {
  final User user;

  Userresult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black12,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => print('tapped'),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.photourl),
                ),
                title: Text(
                  user.displayname,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white10,
            )
          ],
        ));
  }
}
