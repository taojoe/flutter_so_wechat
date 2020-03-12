#import "SoWechatPlugin.h"
#import "WXApi.h"

NSString const *ERROR_APPID_REQUIRED = @"APPID_REQUIRED";
NSString const *ERROR_UNIVERSAL_LINK_REQUIRED = @"UNIVERSAL_LINK_REQUIRED";

BOOL isBlank(NSString* string){
    if (string == nil) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0;
}

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
      NSString *appId = call.arguments[@"appId"];
      if (isBlank(appId)) {
          result([FlutterError errorWithCode:ERROR_APPID_REQUIRED message:@"" details:appId]);
          return;
      }
      NSString *universalLink = call.arguments[@"universalLink"];
      if (isBlank(universalLink)) {
          result([FlutterError errorWithCode:ERROR_UNIVERSAL_LINK_REQUIRED message:@"" details:universalLink]);
          return;
      }
      BOOL isWeChatRegistered = [WXApi registerApp:appId universalLink:universalLink];
      result(@(isWeChatRegistered));
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
