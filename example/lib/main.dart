import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String msg = 'Flutter share is great!!';
  FlutterShareMe shareMe = FlutterShareMe();
  String base;
  XFile image;
  ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              RaisedButton(
                child: Text('Pick image'),
                onPressed: () async {
                  image = await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
              ),
              SizedBox(height: 30),
              RaisedButton(
                child: Text('share to twitter'),
                onPressed: () async {
                  var response = await FlutterShareMe().shareToTwitter(
                      url: 'https://github.com/lizhuoyuan', msg: msg);
                  if (response == 'success') {
                    print('navigate success');
                  }
                },
              ),
              RaisedButton(
                child: Text('share to WhatsApp'),
                onPressed: () {

                  FlutterShareMe().shareToWhatsApp(msg: msg);


                },
              ),
              RaisedButton(
                child: Text('share to WhatsApp Business'),
                onPressed: () async {
                  String response;

                    response =await FlutterShareMe().shareToWhatsApp(msg: msg);

                  print(response);
                },
              ),
              RaisedButton(
                child: Text('share to shareFacebook'),
                onPressed: () {
                  FlutterShareMe().shareToFacebook(
                      url: 'https://pub.dev/packages/flutter_share_me',
                      msg: msg);
                },
              ),
              RaisedButton(
                child: Text('share to System'),
                onPressed: () async {
                  var response = await FlutterShareMe()
                      .shareToSystem(msg: 'Here is the share value');
                  if (response == 'success') {
                    print('navigate success');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
