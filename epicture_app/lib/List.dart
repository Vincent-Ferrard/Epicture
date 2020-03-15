import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'User.dart';

import 'Model/PostList.dart';

class MyList extends StatefulWidget {
  @override
  MyListState createState() => MyListState();
}

class MyListState extends State<MyList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  Future<MyPostList> _list;
  String _etag;


  @override
  Widget build(BuildContext context) {
    if (_list == null)
      setState(() {
        _list = fetchPost();
      });
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Center(
          child: FutureBuilder<MyPostList>(
          future: _list,
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
    Future<MyPostList> newList = fetchPost();
    newList.then((data) {
      if (data != null)
        setState(() {
          _list = newList;
        });
    });
  }

  ListView _buildList(context, images) {
    return new ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, num) {
          return ListTile(
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
                          IconButton(
                            icon: Icon(
                              images[num]['favorite'] == true ? Icons.favorite : Icons
                                  .favorite_border,
                              color: images[num]['favorite'] == true ? Colors.red : null,
                            ),
                            onPressed: () {
                              addFavorite(images[num]['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
            );
        });
  }

  Future<MyPostList> fetchPost() async {

    final response = _etag == null ?
      await http.get('https://api.imgur.com/3/account/${User.username}/images',
        headers: {"Authorization": "Bearer ${User.accessToken}"},
      )
    : await http.get('https://api.imgur.com/3/account/${User.username}/images',
      headers: {"Authorization": "Bearer ${User.accessToken}", "If-None-Match": "$_etag"},
    );

    if (response.statusCode == 200) {
      _etag = response.headers['etag'];
      return MyPostList.fromJson(json.decode(response.body));
    } else if (response.statusCode == 304) {
      return null;
    } else {
      throw Exception('Failed to load post');
    }
  }

  void addFavorite(String id) async {
    final response =
        await http.post('https://api.imgur.com/3/image/$id/favorite',
      headers: {"Authorization": "Bearer ${User.accessToken}"},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load post');
    }
  }
}