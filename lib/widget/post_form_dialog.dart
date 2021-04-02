
import 'package:flutter/material.dart';
import 'package:flutter_doko/model/post.dart';
import 'package:geolocator/geolocator.dart';

class PostFormDialog extends StatefulWidget{

  final Post post;

  PostFormDialog({
    this.post
  });

  _PostFormDialogState createState() => _PostFormDialogState();

}
class _PostFormDialogState extends State<PostFormDialog> {

  final _formKey = GlobalKey<FormState>();
  TextFormField titleFormField;
  TextFormField textFormField;
  TextField latitudeTextField;
  TextField longitudeTextField;


  @override
  void initState(){
    super.initState();

    titleFormField = createTextFormField("title");
    textFormField = createTextFormField("text");
    latitudeTextField = createLocationTextField("latitude");
    longitudeTextField = createLocationTextField("longitude");

    if (widget.post != null){
      //init for update
    }

  }

  @override
  Widget build(BuildContext context) {
    return
      Dialog(
        elevation: 0.0,
        child: dialogContent(context),
      );
  }

  dialogContent(BuildContext context) {

    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              _locationWidget(),
              titleFormField,
              textFormField,
              FloatingActionButton(
                //TODO if update ?
                  child: Icon(Icons.add),
                  heroTag: "addOrUpdatePostBtn",
                  onPressed: ()  {
                    Post post = new Post(
                        title: titleFormField.controller.text,
                        text: textFormField.controller.text,
                        latitude: double.parse(latitudeTextField.controller.text),
                        longitude: double.parse(longitudeTextField.controller.text),
                    );
                    Navigator.pop(context, post);
                  })
            ]
        )
    );
  }



  Widget _locationWidget() {
    return Column(
        children: <Widget>[
          latitudeTextField,
          longitudeTextField,
          FloatingActionButton(
              child: Icon(Icons.gps_fixed),
              heroTag: "getLocationBtn",
              onPressed: () async {
                Position p = await _determinePosition();
                latitudeTextField.controller.text = p.latitude.toString();
                longitudeTextField.controller.text = p.longitude.toString();
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

  TextFormField createTextFormField(String str ){
    return TextFormField(
        controller: new TextEditingController(text: ""),
        decoration: InputDecoration(
          icon: Icon(Icons.title),
          hintText: str,
          labelText: str,
        ),
        validator: (String value) {
          return value.isEmpty ? 'must not be empty' : null;
        }
    );
  }

  createLocationTextField(String str ){
    return TextField(
      controller: new TextEditingController(text: ""),
      decoration: new InputDecoration(labelText: str),
      keyboardType: TextInputType.number,
    );
  }

}