import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Widgets/progress.dart';
//import 'package:social_app/Widgets/progress.dart';

Widget cachedNetworkImage(String mediaUrl) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Padding(
      padding: EdgeInsets.all(20.0),
      child: CircularProgress(),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
