import 'dart:async';

import 'package:flutter/services.dart';

class SoWechat {
  static const MethodChannel _methodChannel = const MethodChannel('com.github.taojoe.so_wechat/method');
  static const EventChannel _streamChannel = const EventChannel('com.github.taojoe.so_wechat/stream');
  static Stream<Map<String, Map>> _eventStream;
  //return appId
  static Future<bool> initApi(String appId, String universalLink) async {
    return await _methodChannel.invokeMethod<String>('initApi', {'appId': appId, 'universalLink':universalLink});
  }
  static Future<bool> sendPayReq(PayReq req) async{
    return await _methodChannel.invokeMethod<bool>('sendPayReq', req.toJson());
  }
  static Stream<Map<String, Map>> respEventStream() {
    if (_eventStream == null) {
       _eventStream = _streamChannel.receiveBroadcastStream().map<Map<String, Map>>((event) => (event as Map<dynamic, dynamic>).cast<String, Map>());
    }
    return _eventStream;
  }
}

class PayReq{
  final String appId;
  final String partnerId;
  final String prepayId;
  final String packageValue;
  final String nonceStr;
  final String timeStamp;
  final String sign;
  final String signType;
  final String extData;
  PayReq({this.appId, this.partnerId, this.prepayId, this.packageValue, this.nonceStr, this.timeStamp, this.sign, this.signType, this.extData});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'appId':this.appId,
    'partnerId':this.partnerId,
    'prepayId':this.prepayId,
    'packageValue':this.packageValue,
    'nonceStr':this.nonceStr,
    'timeStamp':this.timeStamp,
    'sign':this.sign,
    'signType':this.signType,
    'extData':this.extData,
  };
}