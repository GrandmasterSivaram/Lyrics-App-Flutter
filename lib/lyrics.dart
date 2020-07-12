import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LyricsPage extends StatefulWidget {
  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  TextEditingController authorcontroller = TextEditingController();
  TextEditingController musiccontroller = TextEditingController();
  
  String lyrics;

  searchlyrics() async {
    if (authorcontroller.text!= '' && musiccontroller.text !=''){
    var url = 'https://api.lyrics.ovh/v1/${authorcontroller.text}/${musiccontroller.text}';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    if (result['error'] == 'No lyrics found'){
      _globalKey.currentState.showSnackBar(SnackBar(content: Text("No lyrics found"),));
      setState(() {
        lyrics = '';
      });
    }else {
    setState(() {
      lyrics = result['lyrics'];
    });
    }
    }else {
      _globalKey.currentState.showSnackBar(SnackBar(content: Text("Both Input fields must be filled"),));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _globalKey,
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.amber),
          child: Center(
              child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),
              Text("Search for lyrics",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: Colors.pink,
                      fontSize: 30)),
              Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: authorcontroller,
                  decoration: InputDecoration(
                      labelText: "Author Name",
                      labelStyle:
                          GoogleFonts.montserrat(fontWeight: FontWeight.w700),
                      prefixIcon: Icon(Icons.person)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: musiccontroller,
                  decoration: InputDecoration(
                      labelText: "Song Name",
                      labelStyle:
                          GoogleFonts.montserrat(fontWeight: FontWeight.w700),
                      prefixIcon: Icon(Icons.music_note)),
                ),
              )
            ],
          )),
        ),
        Container(
          child: RaisedButton(
            onPressed: () => searchlyrics(),
            color: Colors.purple,
            child: Text(
              "Search",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
        lyrics == null ? Container(): Container(padding: EdgeInsets.all(20),child: Text(lyrics,style: GoogleFonts.montserrat(
          fontWeight:FontWeight.w700,
          color:Colors.purpleAccent,
          fontSize: 18
        ),))
      ],
    )));
  }
}
