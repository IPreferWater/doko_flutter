import 'package:flutter_doko/db/post_repository_abstract.dart';
import 'package:flutter_doko/model/post.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class PostRepository extends PostRepositoryAbstract {
  static const String CATEGORY_STORE_NAME = 'posts_store';

  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store(CATEGORY_STORE_NAME);

  @override
  Future deleteAllPosts() {
    // TODO: implement deleteAllPosts
    throw UnimplementedError();
  }

  @override
  Future deletePost(int postId) async{
    await _store.record(postId).delete(_database);
  }

  @override
  Future<List<Post>> getAllPost() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => Post.fromMap(snapshot.key, snapshot.value))
        .toList(growable: false);
  }

  @override
  Future<int> insertPost(Post post) async{
    return await _store.add(_database, post.toMap());
  }

  @override
  Future updatePost(Post post) async {
    await _store.record(post.id).update(_database, post.toMap());
  }
  }

