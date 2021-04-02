import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_doko/screen/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'db/post_repository.dart';
import 'db/post_repository_abstract.dart';
import 'init.dart';

final storage = FlutterSecureStorage();
void main()  {

  //allow bad certificat
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}


class MyApp extends StatefulWidget{
  @override
  _MyAppState createState()=> _MyAppState();
}
class _MyAppState extends State<MyApp> {

  final Future _init =  Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Favorite Cakes',
      home: FutureBuilder(
        future: _init,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return LoginScreen();
          } else {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }


}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}



