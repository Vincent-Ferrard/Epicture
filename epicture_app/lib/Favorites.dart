import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'User.dart';

import 'Model/PostFavorites.dart';

class MyFavorites extends StatefulWidget {
  @override
  MyFavoritesState createState() => MyFavoritesState();
}

class MyFavoritesState extends State<MyFavorites> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  Future<MyPostFavorites> _favorites;

  @override
  Widget build(BuildContext context) {
    _favorites = fetchPost();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Center(
        child: FutureBuilder<MyPostFavorites>(
          future: _favorites,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildList(context, snapshot.data.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {_favorites = fetchPost();});
    return _favorites;
  }

  ListView _buildList(context, images) {
    return new ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, num) {
          return Card(
            child: ListTile(
              title: CachedNetworkImage(
                imageUrl: images[num]['link'],
                imageBuilder: (context, imageProvider) => Container(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: imageProvider,
                          fit: BoxFit.cover
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<MyPostFavorites> fetchPost() async {
    final response =
    await http.get('https://api.imgur.com/3/account/${User.username}/favorites/',
      headers: {"Authorization": "Bearer ${User.accessToken}"},
    );

    if (response.statusCode == 200) {
      return MyPostFavorites.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}