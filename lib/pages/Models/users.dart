import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String displayname;
  final String photourl;

  User({
    this.id,
    this.username,
    this.email,
    this.displayname,
    this.bio,
    this.photourl,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      photourl: doc['photourl'],
      displayname: doc['displayname'],
      bio: doc['bio'],
    );
  }
}
