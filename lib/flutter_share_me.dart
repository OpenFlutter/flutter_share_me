import 'package:flutter/services.dart';

class FlutterShareMe {
  static const MethodChannel _channel = const MethodChannel('flutter_share_me');

  static void shareToFacebook({String url = '', String msg = ''}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    await _channel.invokeMethod('shareFacebook', arguments);
  }

  static void shareToTwitter({String msg = '', String url = ''}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    await _channel.invokeMethod('shareTwitter', arguments);
  }

  static void shareToWhatsApp({String msg}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    await _channel.invokeMethod('shareWhatsApp', arguments);
  }

  static void shareToSystem({String msg}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    await _channel.invokeMethod('system', {'msg': msg});
  }
}
