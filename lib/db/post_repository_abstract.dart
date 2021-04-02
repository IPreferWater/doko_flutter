import 'package:flutter_doko/model/post.dart';

abstract class PostRepositoryAbstract {

  Future<int> insertPost(Post post);
  Future updatePost(Post post);
  Future deletePost(int cakeId);
  Future deleteAllPosts();
  Future<List<Post>> getAllPost();
}