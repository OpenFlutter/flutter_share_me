import 'package:flutter/services.dart';

class FlutterShareMe {
  final MethodChannel _channel = const MethodChannel('flutter_share_me');

  ///share to facebook
  Future<String?> shareToFacebook({String msg = '', String url = ''}) async {
    final Map<String, dynamic> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    dynamic result;
    try {
      result = await _channel.invokeMethod('shareFacebook', arguments);
    } catch (e) {
      return "false";
    }
    return result;
  }

  ///share to twitter
  Future<String?> shareToTwitter({String msg = '', String url = ''}) async {
    final Map<String, dynamic> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    dynamic result;
    try {
      result = await _channel.invokeMethod('shareTwitter', arguments);
    } catch (e) {
      return "false";
    }
    return result;
  }

  ///share to WhatsApp
  Future<String?> shareToWhatsApp({String msg = '', String base64Image = ''}) async {
    final Map<String, dynamic> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => base64Image);
    dynamic result;
    try {
      result = await _channel.invokeMethod('shareWhatsApp', arguments);
    } catch (e) {
      return "false";
    }

    return result;
  }

  ///share to WhatsApp4Biz
  Future<String?> shareToWhatsApp4Biz({String msg = '', String base64Image = ''}) async {
    final Map<String, dynamic> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => base64Image);
    dynamic result;
    try {
      result = await _channel.invokeMethod('shareWhatsApp4Biz', arguments);
    } catch (e) {
      return "false";
    }

    return result;
  }

  ///use system share ui
  Future<String?> shareToSystem({required String msg}) async {
    Map<String, dynamic> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    dynamic result;
    try {
      result = await _channel.invokeMethod('system', {'msg': msg});
    } catch (e) {
      return "false";
    }
    return result;
  }
}
