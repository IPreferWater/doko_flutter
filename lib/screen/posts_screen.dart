import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_doko/db/post_repository_abstract.dart';
import 'package:flutter_doko/model/post.dart';
import 'package:flutter_doko/widget/post_form_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';

import '../main.dart';

class PostsScreen extends StatefulWidget {
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {

  GraphQLClient client;
  PostRepositoryAbstract _postRepository = GetIt.I.get();

  @override
  void initState() {
    tttt();
    super.initState();
  }

  void tttt() async {
    String token = await storage.read(key: 'token');
    print(token);
    if (token.isEmpty) {
      print("no token found");
      //TODO: navigate back
      return;
    }

    client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: 'https://10.0.2.2:8000/query',
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO: this will have a different txt later
        title: Text('Post'),
        actions: <Widget>[
        ],
      ),
      body: _postsScreen(),
    );
  }

  Widget _postsScreen() {
    return
      Column(
          children: <Widget>[
          _gpsWidget(),
    FloatingActionButton(
    child: Icon(Icons.send),
    heroTag: "sendPostBtn",
    onPressed: () async {
    Post post = await showDialog(
    context: context,
    builder: (BuildContext context) =>
    PostFormDialog());
    int id = await _postRepository.insertPost(post);
    print("postInserted $id");
    })]);
    }
  }

  Widget _gpsWidget() {
    TextField latitudeTextField = TextField(
      controller: new TextEditingController(text: ""),
      decoration: new InputDecoration(labelText: "latitude"),
      keyboardType: TextInputType.number,
    );

    TextField longitudeTextField = TextField(
      controller: new TextEditingController(text: ""),
      decoration: new InputDecoration(labelText: "longitude"),
      keyboardType: TextInputType.number,
    );
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

//TODO: client should be injected
  Future _testGraphQl(GraphQLClient client) async {
    QueryResult result = await client.query(
      QueryOptions(documentNode: gql(
          """ query notes{ notes{ name, steps{ title, txt, url} } } """)),
    );
    print("query done");
    if (result.hasException) {
      print(result.exception);
    } else {
      print(result.data);
    }
  }
