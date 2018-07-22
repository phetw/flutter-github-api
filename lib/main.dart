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
        primarySwatch: Colors.blueGrey,
      ),
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Github profile"),
      ),
      body: _buildProfile(),
    );
  }

  Widget _buildProfile() {
    return profile != null
        ? new Container(
            padding: EdgeInsets.all(50.0),
            child: new Column(
              children: <Widget>[
                new Center(
                  child: new Image.network(
                    profile.avatar,
                    width: 200.0,
                  ),
                ),
                Text(profile.name),
                Text(profile.location),
              ],
            ),
          )
        : null;
  }
}

class Profile {
  final String name;
  final String location;
  final String avatar;

  Profile({
    this.name,
    this.location,
    this.avatar,
  });
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String,
      location: json['location'] as String,
      avatar: json['avatar_url'] as String,
    );
  }
}
