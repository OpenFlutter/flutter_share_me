# flutter_share_me
Flutter Plugin for sharing contents to social media.

### Compatible
#### You can use it share to Facebook , WhatsApp , Twitter And System Share UI. 

Only Android because I don't have a Mac. <br/>

Note: This plugin is still under development, and some APIs might not be available yet. Feedback and Pull Requests are most welcome!
## Getting Started

## Usage

add `flutter_share_me` as a dependency in your pubspec.yaml file.
```
import 'package:flutter_share_me/flutter_share_me.dart';
```

## Methods

#### shareToFacebook({String url, String msg})
#### shareToTwitter({String url, String msg})
#### shareToWhatsApp({String msg})
#### shareToSystem({String msg})

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
```


