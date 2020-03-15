import 'package:flutter/material.dart';

import 'User.dart';

import 'Favorites.dart';
import 'General.dart';
import 'List.dart';
import 'Search.dart';
import 'Upload.dart';

class NavigationTab extends StatefulWidget {
  @override
  NavigationTabState createState() => NavigationTabState();
}

class NavigationTabState extends State<NavigationTab> {
  int _index = 0;

  Widget _getItemWidget(int pos) {
    switch (pos) {
/*      case 0:
        return General();
*/    case 0:
        return MyList();
      case 1:
        return MyFavorites();
      case 2:
        return Search();
      default:
        return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("${User.username}"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (int i) {
          setState(() {
            _index = i;
          });
        },
        items: [
/*          new BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              title: Text('General'),
          ),
*/
          new BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              title: Text('My Images'),
          ),

          new BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorites'),
          ),

          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          )
        ],
      ),
      body: _getItemWidget(_index),
      floatingActionButton: _index == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => MyUpload()),
          );
        },
        child: Icon(Icons.add_photo_alternate),
      ) : null,
    );
  }
}