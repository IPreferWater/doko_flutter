import 'package:flutter/material.dart';

class DropDownTypeSending extends StatefulWidget {
   final Function(String) onCountSelected;

  const DropDownTypeSending({Key key, this.onCountSelected}) : super(key: key);

  @override
  State<DropDownTypeSending> createState() => DropDownTypeSendingState();
}

class DropDownTypeSendingState extends State<DropDownTypeSending> {
  //TODO: get shared preference
  String dropdownValue = 'graphql';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
        widget.onCountSelected(newValue);
      },
      items: <String>['graphql', 'sms', 'mail']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}