# cs492_final_demo

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Very Important Things are 3!
1. store file at phone with path
 
 http protocol use path in smartphone. So it is important that store picture and voice paths.
 



2. http protocol to server with files


AndroidManifest.xml -> 
  <application>
    ...
    <uses-permission android:name="android.permission.INTERNET"/>
    ...
  </application>
    
    
** Use Function

Future<void> gotoVideo() async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse('http://internet URI'));

    request.files.add(
        await http.MultipartFile.fromPath('picture', widget.picture_path));
    request.files
        .add(await http.MultipartFile.fromPath('audio', widget.voice_path));

    request.fields['name'] = temp_name;

    await request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }





3. http get video file from server

VideoPlayerController.network("http://internet URI") 
it's not work. Because it can't read http clear. So we need to add this.

AndroidManifest.xml -> 
 <application
    ...
    android:usesCleartextTraffic="true"
    ...>
 </application>
    
