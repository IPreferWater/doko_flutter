import 'package:flutter/material.dart';

class DropDownTypeSending extends StatefulWidget {
   final Function(String) onCountSelected;
   final String value;


  const DropDownTypeSending({Key key, this.onCountSelected, @required this.value}) : super(key: key);

  @override
  State<DropDownTypeSending> createState() => DropDownTypeSendingState();
}

class DropDownTypeSendingState extends State<DropDownTypeSending> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.value;
    return DropdownButton<String>(
      value: widget.value,
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
      items: <String>['','graphql', 'sms', 'mail']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}