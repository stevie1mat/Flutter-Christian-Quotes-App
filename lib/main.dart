import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url =
      "https://beta.ourmanna.com/api/v1/get/?format=json&order=random";
  String _imageUrl = "https://source.unsplash.com/random/";
  StreamController _streamController;
  Stream _stream;
  Response response;
  int counter = 0;

  getQuotes() async {
    _newImage();
    _streamController.add("waiting");
    response = await get(_url);
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    getQuotes();
  }

  void _newImage() {
    setState(() {
      _imageUrl = 'https://source.unsplash.com/random/$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
        backgroundColor: Colors.black26,
        body: Center(
          child: StreamBuilder(
              stream: _stream,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == "waiting") {
                  return Center(child: Text("Waiting of the Quotes....."));
                }
                return GestureDetector(
                  onTap: () {
                    getQuotes();
                  },
                  child: Stack(
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                        child: Image.network(
                          _imageUrl,
                          fit: BoxFit.fitHeight,
                          width: double.maxFinite,
                          height: double.maxFinite,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(34.0),
                        child: Center(
                            child: Text(
                          snapshot.data['verse']['details']['text']
                              .toString()
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}
