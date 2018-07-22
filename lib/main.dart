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
      var dataConvertedToJSON = JSON.decode(response.body);
      profileJSON = dataConvertedToJSON;
      profile = Profile.fromJson(profileJSON);
      print(profile.name);
    });
    return "Successfull";
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
    return new Container(
      child: new Center(
        child: Text(profile.name),
      ),
    );
  }
}

class Profile {
  final String name;
  final String location;

  Profile({
    this.name,
    // this.location,
  });
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String,
      // location: json['location'] as String,
    );
  }
}
