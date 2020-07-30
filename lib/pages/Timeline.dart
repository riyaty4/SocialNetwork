import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Widgets/header.dart';
import 'package:social_app/Widgets/progress.dart';


//instance to the firestore database and store it in a reference variable
final userref=Firestore.instance.collection('users');


class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

 
  @override
  
  
  Widget build(BuildContext context) {
    return Scaffold(

    appBar: header(context, isApptitle: true),
   
      
    );
  }
}