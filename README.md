# flutter_share_me

[![pub package](https://img.shields.io/pub/v/flutter_share_me.svg)](https://pub.dartlang.org/packages/flutter_share_me)

Flutter Plugin for sharing contents to social media.

You can use it share to Facebook , WhatsApp , Twitter And System Share UI. 
Support Url and Text.

Only Android because I don't have a Mac. 

**Note: This plugin is still under development, and some APIs might not be available yet. Feedback and Pull Requests are most welcome!**

## Getting Started

add `flutter_share_me` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

Please check the latest version before installation.
```
dependencies:
  flutter:
    sdk: flutter
  # add flutter_ScreenUtil
  flutter_share_me: ^0.3.1
``` 

## Usage

#### Add the following imports to your Dart code:

```
import 'package:flutter_share_me/flutter_share_me.dart';
```

#### Add facebook id

Add "facebook app id" to the application tag of AndroidManifest.xml
```
    <application>
       ...
       //add this 
        <meta-data
            android:name="com.facebook.sdk.ApplicationId"
            android:value="@string/facebook_app_id" />
            
    </application>
```

## Methods

#### shareToFacebook({String url, String msg})   
#### shareToTwitter({String url, String msg})   
#### shareToWhatsApp({String msg})  
#### shareToSystem({String msg})   use system share ui

These methods will return "success" if they successfully jump to the corresponding app.

| Parameter  | Description  |
| :------------ | :------------ |
| String msg  | Text message  |
| String url  | Url url  |


## Example
```
 Column(
          children: <Widget>[
            RaisedButton(
              child: Text('share to twitter'),
              onPressed: () async {
                var response = await FlutterShareMe().shareToTwitter(
                    url: 'https://github.com/lizhuoyuan',
                    msg: 'hello flutter! ');
                if (response == 'success') {
                  print('navigate success');
                }
              },
            ),
            RaisedButton(
              child: Text('share to shareWhatsApp'),
              onPressed: () {
                FlutterShareMe().shareToWhatsApp(
                    msg:
                        'hello,this is my github:https://github.com/lizhuoyuan');
              },
            ),
            RaisedButton(
              child: Text('share to shareFacebook'),
              onPressed: () {
                FlutterShareMe().shareToFacebook(
                    url: 'https://github.com/lizhuoyuan', msg: 'Hello Flutter');
              },
            ),
            RaisedButton(
              child: Text('share to System'),
              onPressed: () async {
                var response =
                    await FlutterShareMe().shareToSystem(msg: 'Hello Flutter');
                if (response == 'success') {
                  print('navigate success');
                }
              },
            ),
          ],
        ),
```


