import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../pages/create_page.dart';
import '../pages/update_page.dart';
import '../services/htttp_service.dart';

class HomeViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<Post> posts = [];

  void apiPostList() {
    isLoading = true;
    notifyListeners();
    var result = Network.GET(Network.API_LIST, Network.paramsEmpty()).then((response) => {
          _showResponse(response!),
        });
    print(result.toString());
  }

  void apiPostDelete(Post post) {
    Network.DELETE(
        Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    notifyListeners();
  }

  void _showResponse(String response) {
    var json = jsonDecode(response);
    posts = List<Post>.from(json.map((x) => Post.fromJson(x)));
    isLoading = false;
    notifyListeners();
  }
  void goToCreate(BuildContext context)async{
    var result = await Navigator.push(context,
    MaterialPageRoute(builder: (context)=> const CreatePage()));
    if(result != null){
      posts.add(result as Post);
      apiPostList();
    }
  }

  void goToEdit(BuildContext context, Post post)async{
    var result = await Navigator.push(context,MaterialPageRoute(
        builder: (context)=> UpdatePage(
          post: post,
        )));
    if(result != null){
      posts.replaceRange(posts.indexOf(post), posts.indexOf(post)+1, [result]);
    }
  }
}
