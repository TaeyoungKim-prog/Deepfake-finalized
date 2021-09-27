import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer';

import 'constant.dart';
import 'package:http/http.dart' as http;

import 'homescreen.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key key, this.picture_path, this.voice_path, this.name})
      : super(key: key);

  final String picture_path;
  final String voice_path;
  final String name;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}
// android:usesCleartextTraffic="true" add

class _VideoScreenState extends State<VideoPage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    init_videoplayer();
  }

  void init_videoplayer() {
    _controller = VideoPlayerController.network(
        "http://143.248.171.69:8080/video?username=${widget.name}")
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF2A2826),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    iconSize: 48,
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                picture_path: widget.picture_path,
                                voice_path: widget.picture_path))))),
            SizedBox(height: 60),

            Center(
                child: _controller.value.initialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller))
                    : Container()),

//              AnimatedContainer(
//                curve: Curves.bounceOut,
//                duration: Duration(milliseconds: 700),
//                child: Hero(
//                  tag: "video",
//                  child: Container(
//                    height: 300,
//                    width: 390,
//                    decoration: BoxDecoration(
//                      image: DecorationImage(
//                        fit: BoxFit.fitHeight,
//                        image: AssetImage("assets/video.png"),
//                      ),
//                      color: Color(0xFFF2F2F2),
//                      borderRadius: BorderRadius.circular(25),
//                      border: Border.all(
//                        color: Color(0xFFE5E5E5),
//                      ),
//                      boxShadow: [
//                        BoxShadow(
//                          offset: Offset(0, 4),
//                          blurRadius: 15,
//                          color: Colors.black26,
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
            SizedBox(height: 45),
            Text("This is your Video",
                style: kJetMedium.copyWith(color: Colors.white))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow)),
      ),
    );
  }
}
