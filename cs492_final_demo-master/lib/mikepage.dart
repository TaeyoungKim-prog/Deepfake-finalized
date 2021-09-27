
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cs492_final_demo/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'constant.dart';
import 'dart:io' as io;


class MikePage extends StatefulWidget{
  MikePage({Key key, this.title, this.temp_picture_path, this.temp_voice_path}) : super(key: key);

  final String title;

  final String temp_picture_path;
  final String temp_voice_path;

  @override
  _MikeScreenState createState() => _MikeScreenState();
}


class _MikeScreenState extends State<MikePage> {

  String voice_path;

  var _img = "assets/microphone_two.png";
  double _width = 256;
  int count = 0;


  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  String _alert;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _prepare();
    });
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        //_buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  Future _init() async {
    String customPath = '/flutter_audio_recorder_';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.AAC, sampleRate: 22050);

    await _recorder.initialized;

  }


  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

  void _play() async {
    AudioPlayer player = AudioPlayer();
    player.play(_recording.path, isLocal: true);
  }

  void updateImg() {

    // start recording
    if (count == 0) {
      _startRecording();
    }

    // stop recording
    if (count == 1) {
      _stopRecording();
    }
    if (count > 1 ){
      _play();
    }

    setState(() {
      (count == 0) ? _img = "assets/loading.gif" : _img = "assets/tick.png";
      (count == 0) ? _width = 340 : _width = 255;

      count += 1;
    });
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
                child: IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, iconSize: 48, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HomeScreen(picture_path:widget.temp_picture_path, voice_path:(count > 1)?_recording.path:widget.temp_voice_path))))
            ),
            SizedBox(height:60),
            AnimatedContainer(
              curve: Curves.bounceOut,
              duration: Duration(milliseconds: 700),
              child: InkWell(
                  child: Hero(
                    tag: "mic",
                      child: Image.asset(_img, width: _width)
                  ),
                onTap: () => updateImg(),
              ),
            ),
            SizedBox(height:45),
            (count > 1) ? Text("Done!", style: kJetMedium.copyWith(color: Colors.white)) : Text("Record Your Voice", style: kJetMedium.copyWith(color: Colors.white))
          ],
        )
      ),
    );
  }
}