import Flutter
import UIKit

public class SwiftSoWechatPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "com.github.taojoe.so_wechat/method", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "com.github.taojoe.so_wechat/event", binaryMessenger: registrar.messenger())
    let instance = SwiftSoWechatPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if("initApi"==call.method){
        let appId = call.arguments as! String
        result(appId)
    }else if(call.method.starts(with:"send")){
        result(true)
    }else{
        result("iOS " + UIDevice.current.systemVersion)
    }
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    return nil
  }
}
