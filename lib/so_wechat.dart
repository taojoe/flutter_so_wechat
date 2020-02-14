import 'dart:async';

import 'package:flutter/services.dart';

class SoWechat {
  static const MethodChannel _methodChannel = const MethodChannel('com.github.taojoe.so_wechat/method');
  static const EventChannel _streamChannel = const EventChannel('com.github.taojoe.so_wechat/stream');
  static Stream<Map<String, Map>> _event_stream;
  //return appId
  static Future<String> initApi(String appId) async {
    return await _methodChannel.invokeMethod<String>('initApi', appId);
  }
  static Stream<Map<String, Map>> respEventStream() {
    if (_event_stream == null) {
       _event_stream = _streamChannel.receiveBroadcastStream();
    }
    return _event_stream;
  }
}
