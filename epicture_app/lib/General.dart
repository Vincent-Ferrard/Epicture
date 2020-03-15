import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'User.dart';

import 'Model/PostGeneral.dart';

class General extends StatefulWidget {
  @override
  GeneralState createState() => GeneralState();
}

class GeneralState extends State<General> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  Future<MyPostGeneral> _general;

  @override
  Widget build(BuildContext context) {
    _general = fetchPost();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Center(
        child: FutureBuilder<MyPostGeneral>(
          future: _general,
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
    setState(() {_general = fetchPost();});
    return _general;
  }

  ListView _buildList(context, images) {
    return new ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, num) {
          if (images[num]['images'][0]['type'] != null && images[num]['images'][0]['type'].split('/')[0] == "image") {
            return Card(
              child: ListTile(
                title: Image(
                  image: NetworkImage(images[num]['images'][0]['link']),
                ),
                subtitle: IconButton(
                  icon: Icon(
                    images[num]['images'][0]['favorite'] == true ? Icons.favorite : Icons
                        .favorite_border,
                    color: images[num]['images'][0]['favorite'] == true ? Colors.red : null,
                  ),
                  onPressed: () {
                    addFavorite(images[num]['images'][0]['id']);
                  },
                ),
              ),
              margin: EdgeInsets.all(20.0),
            );
          } else {
            return null;
          }
        });
  }

  Future<MyPostGeneral> fetchPost() async {
    final response =
    await http.get('https://api.imgur.com/3/gallery/hot/viral/day/0',
      headers: {"Authorization": "Client-ID a406d8e0f3c84c6"},
    );

    if (response.statusCode == 200) {
      return MyPostGeneral.fromJson(json.decode(response.body));
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