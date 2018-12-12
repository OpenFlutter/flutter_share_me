import 'package:flutter/services.dart';

class FlutterShareMe {
  static const MethodChannel _channel = const MethodChannel('flutter_share_me');

  static Future<String> shareToFacebook(
      {String url = '', String msg = ''}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    return await _channel.invokeMethod('shareFacebook', arguments);
  }

  static Future<String> shareToTwitter(
      {String msg = '', String url = ''}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    return await _channel.invokeMethod('shareTwitter', arguments);
  }

  static Future<String> shareToWhatsApp({String msg}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    return await _channel.invokeMethod('shareWhatsApp', arguments);
  }

  static Future<String> shareToSystem({String msg}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    return await _channel.invokeMethod('system', {'msg': msg});
  }

}
