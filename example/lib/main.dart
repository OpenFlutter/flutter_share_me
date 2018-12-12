import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('share to twitter'),
              onPressed: () {
                FlutterShareMe.shareToTwitter(
                    url: 'https://github.com/lizhuoyuan',
                    msg: 'hello flutter! ');
              },
            ),
            RaisedButton(
              child: Text('share to shareWhatsApp'),
              onPressed: () {
                FlutterShareMe.shareToWhatsApp(
                    msg:
                    'hello,this is my github:https://github.com/lizhuoyuan');
              },
            ),
            RaisedButton(
              child: Text('share to shareFacebook'),
              onPressed: () {
                FlutterShareMe.shareToFacebook(
                    url: 'https://github.com/lizhuoyuan', msg: 'Hello Flutter');
              },
            ),
            RaisedButton(
              child: Text('share to System'),
              onPressed: () {
                FlutterShareMe.shareToSystem(msg: 'Hello Flutter');
              },
            ),
          ],
        ),
      ),
    );
  }
}
