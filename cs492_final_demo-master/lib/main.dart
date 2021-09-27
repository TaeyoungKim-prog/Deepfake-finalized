import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';

import 'homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fake Presentation',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "NotoSans",
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.blueGrey)),
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(child: HomeScreen(title: 'Flutter Demo Home Page', picture_path:null, voice_path: null)),
    );
  }
}
