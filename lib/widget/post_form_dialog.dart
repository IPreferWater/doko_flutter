
import 'package:flutter/material.dart';
import 'package:flutter_doko/model/post.dart';

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


  @override
  void initState(){
    super.initState();

    titleFormField = createTextFormField("title");
    textFormField = createTextFormField("text");

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
              //_gpsWidget(),
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
                        latitude: 5.45678,
                        longitude: 7.56789
                    );

                    Navigator.pop(context, post);
                  })
            ]
        )
    );
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
}