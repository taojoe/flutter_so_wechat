#import "SoWechatPlugin.h"

@interface SoWechatPlugin() <FlutterStreamHandler>
@property (copy, nonatomic)   FlutterEventSink   flutterEventSink;
@end

@implementation SoWechatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"com.github.taojoe.so_wechat/method" binaryMessenger:[registrar messenger]];
    FlutterEventChannel* stream = [FlutterEventChannel eventChannelWithName:@"com.github.taojoe.so_wechat/event" binaryMessenger:registrar.messenger];
    SoWechatPlugin* instance = [[SoWechatPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [stream setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"initApi" isEqualToString:call.method]) {
      NSString* appId = call.arguments;
      result(appId);
  } else if([@"send" isEqualToString:call.method]){
      result([NSNumber numberWithBool:true]);
  }else {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
}

-(FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.flutterEventSink = events;
    return nil;
}

-(FlutterError*)onCancelWithArguments:(id)arguments {
    return nil;
}

@end
