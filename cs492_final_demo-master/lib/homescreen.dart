import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'cameraPage.dart';
import 'constant.dart';
import 'mikepage.dart';
import 'transition.dart';
import 'videoPage.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String picture_path;
  final String voice_path;

  HomeScreen({Key key, this.title, this.picture_path, this.voice_path})
      : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String temp_picture_path;
  String temp_voice_path;
  String temp_name;

  CameraController controller;
  List<CameraDescription> cameras;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init_camera();
    temp_picture_path = widget.picture_path;
    temp_voice_path = widget.voice_path;
    temp_name = DateTime.now().millisecondsSinceEpoch.toString();
    print(temp_name);
  }

  void init_camera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        ClipPath(
          clipper: MyClipper(),
          child: Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("assets/orator.jpg"),
              ),
            ),
          ),
        ),
        //deepfake Presentation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(" deepfake ", style: kJetMedium.copyWith(fontSize: 20)),
            Text("Presentation", style: kJetBold),
          ],
        ),
        //Two simple steps
        Padding(
          padding: const EdgeInsets.all(22),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Two simple steps", style: kJetMedium),
                  ],
                ),
                Row(
                  children: [
                    Text("To make your presentation",
                        style: kJetMedium.copyWith(
                            fontSize: 15, color: Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
        ),
        //Camera
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Color(0xFFE5E5E5)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 15,
                color: Colors.black26,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 20),
              (widget.picture_path == null)
                  ? Text("Click the camera to take a picture.",
                      style: kJetMedium.copyWith(fontSize: 12))
                  : Text(".."+widget.picture_path.substring((widget.picture_path.length > 30)?widget.picture_path.length-30:0),
                  style: kJetMedium.copyWith(fontSize: 12)),
              Expanded(child:Container()),
              Padding(
                padding: const EdgeInsets.only(right:15.0),
                child: InkWell(
                  child: Hero(
                    tag: "camera",
                    child: Image.asset(
                      "assets/photograph.png",
                      width: 40,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        BouncyPageRoute(
                            widget: CameraPage(
                                camera: cameras[1],
                                temp_voice_path: temp_voice_path)));
                  },
                ),
              ),
            ],
          ),
        ),
        //spacing
        Container(
          height: 15,
        ),
        //Microphone
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Color(0xFFE5E5E5),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 15,
                color: Colors.black26,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 20),
              (widget.voice_path == null)
                  ? Text("Click the mic to record your voice.",
                      style: kJetMedium.copyWith(fontSize: 12))
                  : Text(".."+widget.voice_path.substring((widget.voice_path.length>30)?widget.voice_path.length-30 : 0 ),
                  style: kJetMedium.copyWith(fontSize: 12)),
              Expanded(child:Container()),
              Padding(
                padding: const EdgeInsets.only(right:15.0),
                child: InkWell(
                  child: Hero(
                    tag: "mic",
                    child: Image.asset(
                      "assets/microphone_two.png",
                      width: 40,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, BouncyPageRoute(widget: MikePage(temp_picture_path: temp_picture_path,temp_voice_path: temp_voice_path,)));
                  },
                ),
              ),
            ],
          ),
        ),
        //Check Video
        Padding(
          padding: const EdgeInsets.all(22),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Check out your video", style: kJetMedium),
                  ],
                ),
                Row(
                  children: [
                    Text("your final video",
                        style: kJetMedium.copyWith(
                            fontSize: 15, color: Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Container(width: 60),
            Hero(
              tag: "video",
              child: Container(
                height: 100,
                width: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage("assets/video.png"),
                  ),
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Color(0xFFE5E5E5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 15,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 30),
            Container(
              height: 30,
              width: 115,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 15,
                    color: Colors.black54,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.center,
                child: InkWell(
                  child: Text("View video",
                      style: kJetMedium.copyWith(
                          fontSize: 15, color: Colors.white)),
                  onTap: () {

                    gotoVideo();
                    print(temp_voice_path);
                    print(temp_picture_path);
                    Navigator.push(context, BouncyPageRoute(widget: VideoPage(voice_path: temp_voice_path, picture_path: temp_picture_path, name:"girl")));

                   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoPage(voice_path: temp_voice_path, picture_path: temp_picture_path, name:"girl")));

                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Future<void> gotoVideo() async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse('http://143.248.171.69:8080/getImage'));

    request.files.add(
        await http.MultipartFile.fromPath('picture', widget.picture_path));
    request.files
        .add(await http.MultipartFile.fromPath('audio', widget.voice_path));

    request.fields['name'] = temp_name;

    await request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }

}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
