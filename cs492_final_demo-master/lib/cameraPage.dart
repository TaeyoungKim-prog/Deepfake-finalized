import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'constant.dart';
import 'homescreen.dart';

import 'dart:io' as io;

class CameraPage extends StatefulWidget{

  CameraPage({Key key, this.title, this.camera, this.temp_voice_path, this.temp_picture_path}) : super(key: key);

  final CameraDescription camera;

  final String temp_picture_path;
  final String temp_voice_path;

  final String title;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}


class _CameraScreenState extends State<CameraPage> {


  String filePath_0;

  CameraController _controller;
  Future<void> _initializeControllerFuture;

  var _imgMic = "assets/photograph.png";
  double _width = 100;
  bool photoTaken = false;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      // 이용 가능한 카메라 목록에서 특정 카메라를 가져옵니다.
      widget.camera,
      // 적용할 해상도를 지정합니다.
      ResolutionPreset.medium,
    );
    filePath_0  = widget.temp_picture_path;

    // 다음으로 controller를 초기화합니다. 초기화 메서드는 Future를 반환합니다.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateImg() {
    takePicture();
    setState(() {
        photoTaken = true;
       _imgMic = "assets/tick.png";
       _width = 95;
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
                child: IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, iconSize: 48, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(picture_path: photoTaken?filePath_0:widget.temp_picture_path, voice_path: widget.temp_voice_path,))))
            ),
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Future가 완료되면, 프리뷰를 보여줍니다.
                    return Center(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.6 / _controller.value.aspectRatio,
                          width: MediaQuery.of(context).size.width * 0.6 ,
                          child: Stack(
                            children: [
                              CameraPreview(_controller),
                              Center(child: Image.asset('assets/mark.png'))
                            ],
                          )),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              SizedBox(height:20),
              (photoTaken)? Text("Done!", style: kJetMedium.copyWith(color: Colors.white)) : Text("Take your Picture", style: kJetMedium.copyWith(color: Colors.white)),
              SizedBox(height:45),
              AnimatedContainer(
                curve: Curves.bounceOut,
                duration: Duration(milliseconds: 700),
                child: InkWell(
                  child: Hero(
                      tag: "camera",
                      child: Image.asset(_imgMic, width: _width)
                  ),
                  onTap: () => updateImg(),
                ),
              ),
            ],
          )
      ),
    );
  }

  Future<void> takePicture() async {

    if (!_controller.value.isInitialized) {
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();

    String customPath = '/Pictures';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path + customPath;

    await Directory(customPath).create(recursive: true);
    final String filePath = '$customPath/picture_${DateTime.now().microsecondsSinceEpoch}.png';
    filePath_0 = filePath;

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await _controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

  }

  void _showCameraException(CameraException e) {
    print(e.code);
    print(e.description);
  }
}