import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:image_picker/image_picker.dart';

enum Share { facebook, twitter, whatsapp, whatsapp_business, share_system }

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String msg = 'hello,this is my github:https://github.com/lizhuoyuan';
  String base64Image = '';
  XFile? file;
  ImagePicker picker = ImagePicker();

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
              ElevatedButton(
                  onPressed: () async {
                    file = await picker.pickImage(source: ImageSource.camera);
                    print(file);
                    setState(() {});
                  },
                  child: Text('Pick Image')),
              ElevatedButton(
                  onPressed: () => onButtonTap(Share.twitter),
                  child: Text('share to twitter')),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.whatsapp),
                child: Text('share to WhatsApp'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.whatsapp_business),
                child: Text('share to WhatsApp  Business'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.facebook),
                child: Text('share to  FaceBook'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.share_system),
                child: Text('share to System'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onButtonTap(Share share) async {
    String msg =
        'Flutter share is great!!\n Check out full example at https://pub.dev/packages/flutter_share_me';
    String url = 'https://pub.dev/packages/flutter_share_me';

    String? response;
    FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case Share.facebook:
        response = await flutterShareMe.shareToFacebook(url: url, msg: msg);
        break;
      case Share.twitter:
        response = await flutterShareMe.shareToTwitter(url: url, msg: msg);
        break;
      case Share.whatsapp:
        if(file!=null){
          response = await flutterShareMe.shareToWhatsApp(
              msg: msg,imageUrl: file!.path);
        }else{
          response = await flutterShareMe.shareToWhatsApp(
              msg: msg);
        }

        break;
      case Share.whatsapp_business:
        response = await flutterShareMe.shareToWhatsApp(msg: msg);

        break;
      case Share.share_system:
        response = await flutterShareMe.shareToSystem(msg: msg);

        break;
    }

    print(response);
  }
}
