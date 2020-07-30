import 'package:flutter/material.dart';
AppBar header(context,{bool isApptitle = false, String titleText, removebackbutton = false})
{
  return AppBar(
    automaticallyImplyLeading: removebackbutton?false:true,
    title: Text(
      isApptitle ? "ButterFly" : titleText,
    style: TextStyle(
      color: isApptitle?Colors.white:Colors.black,
      fontFamily: isApptitle?"Signatra":"",
      fontSize: isApptitle?45.0:20.0,
    ),
    ) ,
    centerTitle: true,
    backgroundColor: isApptitle?Theme.of(context).primaryColor: Colors.white,
    
    );
    
}