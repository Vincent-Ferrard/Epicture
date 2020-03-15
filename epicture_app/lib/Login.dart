import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'User.dart';

import 'NavigationTab.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      url = url.replaceFirst('#', '?');
      Uri uri = Uri.dataFromString(url);
      print("URL OK : $url");
      if (uri.queryParameters["access_token"] != null) {
        setState(() {
          print("${uri.queryParameters["access_token"]}");
          User.accessToken = uri.queryParameters["access_token"];
          User.expiresIn = uri.queryParameters["expires_in"];
          User.tokenType = uri.queryParameters["token_type"];
          User.refreshToken = uri.queryParameters["refresh_token"];
          User.username = uri.queryParameters["account_username"];
          User.id = uri.queryParameters["account_id"];
        });
        flutterWebviewPlugin.close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (User.accessToken == null) ? WebviewScaffold(
      url: "https://api.imgur.com/oauth2/authorize?client_id=a406d8e0f3c84c6&response_type=token",
    ) : NavigationTab();
  }
}