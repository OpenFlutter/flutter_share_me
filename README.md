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
  # add flutter_share_me
  flutter_share_me: ^0.4.0
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

#### shareToFacebook({String msg, String url})   
#### shareToTwitter({String msg, String url})   
#### shareToWhatsApp({String msg,String base64Image})  
#### shareToWhatsApp4Biz({String msg,String base64Image})  
#### shareToSystem({String msg})   use system share ui

These methods will return "success" if they successfully jump to the corresponding app.

| Parameter  | Description  |
| :------------ | :------------ |
| String msg  | Text message  |
| String url  | Url url  |
| String base64Image  | Image base64  |

## Example
```
 Container(
           width: double.infinity,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               Image.memory(
                 base64.decode(base64Image.split(',')[1]),
                 height: 312,
                 width: 175.3,
                 fit: BoxFit.fill,
                 gaplessPlayback: true,
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
                   FlutterShareMe()
                       .shareToWhatsApp(base64Image: base64Image, msg: msg);
                 },
               ),
               RaisedButton(
                 child: Text('share to WhatsApp Business'),
                 onPressed: () {
                   FlutterShareMe()
                       .shareToWhatsApp4Biz(base64Image: base64Image, msg: msg);
                 },
               ),
               RaisedButton(
                 child: Text('share to shareFacebook'),
                 onPressed: () {
                   FlutterShareMe().shareToFacebook(
                       url: 'https://github.com/lizhuoyuan', msg: msg);
                 },
               ),
               RaisedButton(
                 child: Text('share to System'),
                 onPressed: () async {
                   var response = await FlutterShareMe().shareToSystem(msg: msg);
                   if (response == 'success') {
                     print('navigate success');
                   }
                 },
               ),
             ],
           ),
         )
```


