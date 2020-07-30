import 'package:flutter/material.dart';
Container CircularProgress()
{
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top:10.0),
    child: CircularProgressIndicator(
      valueColor:AlwaysStoppedAnimation(Colors.purple),
      )
  );
}
Container LinearProgress()
{
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor:AlwaysStoppedAnimation(Colors.red[300])
    ),
    );
}

