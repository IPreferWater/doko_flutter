import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_doko/screen/mail_screen.dart';
import 'package:flutter_doko/screen/posts_screen.dart';
import 'package:flutter_doko/screen/sms_screen.dart';
import 'package:flutter_doko/widget/drop_down_type_sending.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String sendingType = '';

  @override initState()  {
    initSendingType();
    super.initState();
  }

  initSendingType() async {
    String sendingTypeFromSharedPrefs = await getStringValuesSF();
    setState(() {
      sendingType = sendingTypeFromSharedPrefs;
    });
  }

  Future<String> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String s = prefs.getString('sending_type');
    print('sending_type found is $s');
    if (s == null) {
      return 'graphql';
    }
    return s;
  }

  Future<void> setStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sending_type', sendingType);
    print('new sending_type is $sendingType');
  }


  @override
  Widget build(BuildContext context) {
print("rebuild!!!!! with $sendingType");
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
        actions: <Widget>[],
      ),
      body: Column(children: <Widget>[
        DropDownTypeSending(
          value: sendingType,
          onCountSelected: (String s) {
            setState(() {
              sendingType = s;
            });
            setStringValuesSF();
          },
        ),

        getWidgetToDisplay()





      ]),
    );
  }

Widget getWidgetToDisplay(){
  switch(sendingType) {
    case 'graphql': {
      return _loginScreen();
    }
    break;

    case 'sms': {
      return _sms();
    }
    break;

    case 'mail': {
      return _mail();
    }
    break;

    default: {
      return Text("loading");
    }
    break;
  }
}
  Widget _sms() {
    return  FloatingActionButton(
        child: Icon(Icons.check),
        heroTag: "smsBtn",
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SmsScreen()),
          );
        });
  }

  Widget _mail() {
    return  FloatingActionButton(
        child: Icon(Icons.check),
        heroTag: "smsBtn",
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MailScreen()),
          );
        });
  }

  Widget _loginScreen() {
    TextFormField usernameTextFormField = TextFormField(
        controller: new TextEditingController(text: "ipreferwater"),
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: "username",
          labelText: "username",
        ),
        validator: (String value) {
          return value.isEmpty ? 'must not be empty' : null;
        });

    TextFormField passwordTextFormField = TextFormField(
        controller: new TextEditingController(text: "password"),
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.vpn_key),
          hintText: "password",
          labelText: "password",
        ),
        validator: (String value) {
          return value.isEmpty ? 'must not be empty' : null;
        });
    return Column(children: <Widget>[
      usernameTextFormField,
      passwordTextFormField,
      FloatingActionButton(
          child: Icon(Icons.check),
          heroTag: "loginBtn",
          onPressed: () async {
            String username = usernameTextFormField.controller.text;
            String password = passwordTextFormField.controller.text;
            bool isConnected = await login(username, password);

            print('can connect = $isConnected');
            if (!isConnected) {
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostsScreen()),
            );
          })
    ]);
  }

  Future<bool> login(String username, String password) async {

    var url = Uri.parse('https://10.0.2.2:8000/login');
    final body = jsonEncode({"username": username, "password": password});
    var response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body)
        .timeout(Duration(seconds: 8), onTimeout: () {
      print("timeout!");
      return null;
    });
    if (response == null) {
      //todo: print error can't reach api
      return false;
    }
    if (response.statusCode != 200) {
      //todo: print error login
      return false;
    }

    String token = getToken(response.body);
    await storage.write(key: 'token', value: token);

    return true;
  }

  String getToken(String body) {
    Map<String, dynamic> jsonRes = jsonDecode(body);

    String token = jsonRes["access_token"];

    return token;
  }
}
