import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_doko/db/post_repository_abstract.dart';
import 'package:flutter_doko/model/post.dart';
import 'package:flutter_doko/widget/post_form_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../main.dart';

class MailScreen extends StatefulWidget {
  _MailScreenState createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {

  final _formKey = GlobalKey<FormState>();

  final recipientController = TextEditingController();
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();


  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
   //get shared prefs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mail'),
        actions: <Widget>[
        ],
      ),
      body: _mailScreen(),
    );
  }

  Widget _mailScreen(){
    return Form(
      key: _formKey,
        child: Column(
      children: [
        _locationWidget(),
        TextFormField(
            controller: recipientController,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email_outlined),
              hintText: "recipient",
              labelText: "recipient",
            ),
            validator: (String value) {
              bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
              return !emailValid ? 'mail adress not correct' : null;
            }
        ),
        TextFormField(
            controller: subjectController,
            decoration: InputDecoration(
              hintText: "subject",
              labelText: "subject",
            ),
        ),
        TextFormField(
            controller: bodyController,
            decoration: InputDecoration(
              hintText: "body",
              labelText: "body",
            ),
        ),
        FloatingActionButton(
            child: Icon(Icons.outgoing_mail),
            onPressed: (){

          if (_formKey.currentState.validate()){
           // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error?")));
            _sendMail();
          }
        })

      ],
    ));
  }

  //TODO duplicated code
  Widget _locationWidget() {
    return Column(
        children: <Widget>[
          TextField(
            controller: latitudeController,
            decoration: new InputDecoration(labelText: "latitude"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: longitudeController,
            decoration: new InputDecoration(labelText: "longitude"),
            keyboardType: TextInputType.number,
          ),
          FloatingActionButton(
              child: Icon(Icons.gps_fixed),
              heroTag: "getLocationBtn",
              onPressed: () async {
                Position p = await _determinePosition();
                latitudeController.text = p.latitude.toString();
                longitudeController.text = p.longitude.toString();
              })
        ]);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


_sendMail() async {
  final Email email = Email(
    //https://www.latlong.net/c/?lat=50.638120&long=3.050870
    body: ' <a href="">position on latlong.net</a>.'
        '<p> mes coordonées ${latitudeController.text} ${longitudeController.text} => https://www.latlong.net/c/?lat=${latitudeController.text}&long=${longitudeController.text}</p>'
        '<p> message :  ${bodyController.text}</p>',
    subject: subjectController.text,
    recipients: [recipientController.text],
    isHTML: true,
  );

  await FlutterEmailSender.send(email);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("mail sent")));
}
  }