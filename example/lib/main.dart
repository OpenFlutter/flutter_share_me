import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? file;
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
              ElevatedButton(onPressed: pickImage, child: Text('Pick Image')),
              ElevatedButton(
                  onPressed: () => onButtonTap(Share.twitter),
                  child: const Text('share to twitter')),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.whatsapp),
                child: const Text('share to WhatsApp'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.whatsapp_business),
                child:const  Text('share to WhatsApp  Business'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.whatsapp_personal),
                child: const Text('share to WhatsApp  Personal'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.facebook),
                child:const  Text('share to  FaceBook'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.share_system),
                child: const Text('share to System'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    print(xFile);
    Uint8List u = await xFile!.readAsBytes();
    await getFile();
    if (!file!.existsSync()) {
      file!.createSync();
      print('create file:$file');
    }
    file!.writeAsBytesSync(u);
    if (file!.existsSync()) {
      print('image save success,path:${file!.path}');
    }
  }

  Future<void> getFile() async {
    Directory tempDir = await getTemporaryDirectory();
    file = File('${tempDir.path}/img${DateTime.now()}.png');
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
        if (file != null) {
          response = await flutterShareMe.shareToWhatsApp(
              msg: msg, imagePath: file!.path);
        } else {
          response = await flutterShareMe.shareToWhatsApp(msg: msg);
        }
        break;
      case Share.whatsapp_business:
        response = await flutterShareMe.shareToWhatsApp(msg: msg);

        break;
      case Share.share_system:
        response = await flutterShareMe.shareToSystem(msg: msg);
        break;
      case Share.whatsapp_personal:
        response = await flutterShareMe.shareWhatsAppPersonalMessage(
            message: msg, phoneNumber: '918200188632');
        break;
    }

    print(response);
  }
}
