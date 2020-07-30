import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app/Widgets/header.dart';
class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final formkey=GlobalKey<FormState>();
  final Scaffoldkey=GlobalKey<ScaffoldState>();
  String username;

  submit()
  {
    final form= formkey.currentState;
    if(form.validate()){

      form.save();
      final snackBar= SnackBar(content: Text('Welcome $username'),);
      Scaffoldkey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2), ()
      {
        Navigator.pop(context, username);
      });
      
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Scaffoldkey,
      appBar: header(context, titleText: "Set up your profile",removebackbutton: true),
      body: ListView(children: <Widget>[
        Container(
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 25.0),
            child: Center
            (
                 child: Text("Create user name", style: TextStyle(
              
              fontFamily: "Signatra",
              fontSize: 25.0,
              fontStyle: FontStyle.italic,
              
              ),

              ),
            ) 
            ),
            Padding(padding: EdgeInsets.all(16.0),
            child: Form(
              key: formkey,
                child: TextFormField(
                onSaved: (val) {
                  username=val;
                },
                autovalidate: true,
                validator: (val)
                {
                  if(val.trim().length <3 || val.isEmpty)
                  return 'user name too short';
                  else if(val.trim().length>12)
                  return "user name too long";
                  else
                  return null;
                },
                decoration: InputDecoration(icon: Icon(Icons.account_circle,
                ),
                border: OutlineInputBorder(),
                labelText: "Username",
                labelStyle: TextStyle(
                  fontSize: 15.0,

                ),
                hintText: "input at least 3 character",
                )

              )
              )
            
            ),

            GestureDetector(
              onTap: submit,
              child: Container(
                height: 50.0,
                width: 250.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Center(
                  child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                  ),

              
              ),
                ),
              ),
            ),
          ],
          ),
        )

      ],),
      
    );
  }
}