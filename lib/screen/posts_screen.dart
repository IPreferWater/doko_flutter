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
    FloatingActionButton(
    child: Icon(Icons.add),
    heroTag: "sendPostBtn",
    onPressed: () async {
    Post post = await showDialog(
    context: context,
    builder: (BuildContext context) =>
    PostFormDialog());
    int id = await _postRepository.insertPost(post);
    print("postInserted $id");
    }),
            FloatingActionButton(

                child: Icon(Icons.send),
                heroTag: "sendAllPostsBtn",
                onPressed: () async {
                  List <Post> posts = await _postRepository.getAllPost();
                  Map<String, dynamic> cheat = new Map<String,dynamic>();
                  String mutationStr = """
                   mutation CreatePosts(\$newposts: [InputPost!]!) {
  createPosts(input: \$newposts)
}
""";

            cheat["newposts"]=posts[0].toMap();
                  QueryResult queryResult = await client.query(
                    QueryOptions(documentNode: gql(mutationStr), variables: cheat),
                  );
                  print(queryResult.data);
                  print(queryResult.exception);
                })
          ]);
    }
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
