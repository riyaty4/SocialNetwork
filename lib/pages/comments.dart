//import 'dart:html';
import 'package:social_app/Widgets/progress.dart';

import 'home.dart';

import 'package:flutter/material.dart';
import 'package:social_app/Widgets/header.dart';

class Comments extends StatefulWidget {
  final String postid;
  final String ownerid;
  final String mediaurl;
  Comments({this.postid, this.ownerid, this.mediaurl});
  @override
  _CommentsState createState() => _CommentsState(
        postId: this.postid,
        ownerId: this.ownerid,
        mediaUrl: this.mediaurl,
      );
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String ownerId;
  final String mediaUrl;
  _CommentsState({this.postId, this.ownerId, this.mediaUrl});

  buildComments() {
    return StreamBuilder(
      stream: commentsRef
          .document(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgress();
        }
      },
    );
  }

  addComment() {
    commentsRef.document(postId).collection("comments").add({
      "username": currentuser.username,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentuser.photourl,
      "userId": currentuser.id,
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "write a comment..",
              ),
            ),
            trailing: OutlineButton(
                borderSide: BorderSide.none,
                child: Text("Post"),
                onPressed: addComment),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  // const Comment({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
