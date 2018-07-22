import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter - Github API',
      theme: new ThemeData(
          primarySwatch: Colors.blueGrey, fontFamily: 'RobotoMono'),
      home: new MyGithubProfilePage(),
    );
  }
}

class MyGithubProfilePage extends StatefulWidget {
  @override
  _MyGithubProfileState createState() => new _MyGithubProfileState();
}

class _MyGithubProfileState extends State<MyGithubProfilePage> {
  final String url = "https://api.github.com/users/rappad";
  Object profileJSON;
  Profile profile;

  Future<String> getJSONData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      if (response.statusCode == 200) {
        var dataConvertedToJSON = JSON.decode(response.body);
        profileJSON = dataConvertedToJSON;
        profile = Profile.fromJson(profileJSON);
      } else {
        throw Exception('Error fetching data');
      }
    });
    return "Successful";
  }

  @override
  void initState() {
    super.initState();
    this.getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    final String title = profile == null ? "My Github profile" : profile.login;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        elevation: 4.5,
      ),
      body: _buildProfile(),
    );
  }

  Widget _buildProfile() {
    final TextStyle _nameFont =
        new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500);
    final TextStyle _normalFont =
        new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300);

    return profile != null
        ? new Container(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new Image.network(
                    profile.avatar,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    profile.name,
                    style: _nameFont,
                  ),
                ),
                Divider(),
                new Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    profile.location,
                    style: _normalFont,
                  ),
                )
              ],
            ),
          )
        : null;
  }
}

class Profile {
  final String login;
  final String name;
  final String location;
  final String avatar;

  Profile({
    this.login,
    this.name,
    this.location,
    this.avatar,
  });
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      login: json['login'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      avatar: json['avatar_url'] as String,
    );
  }
}
