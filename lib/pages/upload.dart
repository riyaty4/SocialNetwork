import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_app/Widgets/progress.dart';
import 'package:social_app/pages/Models/users.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

import 'home.dart';

class Upload extends StatefulWidget {
  final User currentUser;

  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File file;
  bool isuploading = false;
  String postId = Uuid().v4();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  handletakephoto() async {
    //removes the dialogue box
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  handlechoosefromGallery() async {
    // remove the dialogue box
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Photo with camera",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: handletakephoto,
              ),
              SimpleDialogOption(
                child: Text(
                  "Upload from Gallery",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: handlechoosefromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container buildsplashscreen() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: 260.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
                color: Colors.deepOrange[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Upload Image",
                  style: TextStyle(
                    fontFamily: "Signatra",
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                //  color: Colors.orange,
                onPressed: () => selectImage(context)),
          ),
        ],
      ),
    );
  }

  clearimage() {
    setState(() {
      file = null;
    });
  }

  compressimage() async {
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    Im.Image imagefile = Im.decodeImage(file.readAsBytesSync());
    final compressedimage = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imagefile, quality: 85));
    setState(() {
      file = compressedimage;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadtask =
        storageref.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storagesnap = await uploadtask.onComplete;
    String downloadurl = await storagesnap.ref.getDownloadURL();
    return downloadurl;
  }

  createPostInFirestore(
      {String mediaUrl, String location, String description}) {
    postref
        .document(widget.currentUser.id)
        .collection("userPosts")
        .document(postId)
        .setData({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "username": widget.currentUser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "timestamp": timestamp,
      "likes": {},
    });
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isuploading = false;
      postId = Uuid().v4();
    });
  }

  handlesubmit() async {
    setState(() {
      isuploading = true;
    });
    await compressimage();
    String mediaurl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaurl,
      location: locationController.text,
      description: captionController.text,
    );
  }

  builduploadform() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: clearimage,
        ),
        title: Text(
          "Caption Post",
          style: TextStyle(
            fontFamily: "Signatra",
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: isuploading ? null : () => handlesubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          isuploading ? LinearProgress() : Text(" "),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.currentUser.photourl),
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: "Write a Caption..",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.deepOrangeAccent,
              size: 35,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Where was the picture taken..?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              onPressed: getuserLocation,
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              label: Text(
                "Use current Location..",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }

  getuserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placemark = placemarks[0];
    String completeAdress =
        '${placemark.subThoroughfare}, ${placemark.thoroughfare}, ${placemark.subLocality}${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}';
    String formattedAddress = "${placemark.locality}, ${placemark.country}";

    print(completeAdress);
    locationController.text = formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildsplashscreen() : builduploadform();
  }
}
