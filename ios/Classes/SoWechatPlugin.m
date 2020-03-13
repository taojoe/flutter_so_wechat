#import "SoWechatPlugin.h"
#import "WXApi.h"
#import<objc/runtime.h>

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

BaseReq* dataToReq(NSString* name, id data){
    PayReq *request = [[PayReq alloc] init];
    //request.openID = data[@"appId"];
    request.partnerId = data[@"partnerId"];
    request.prepayId= data[@"prepayId"];
    request.package = data[@"packageValue"];
    request.nonceStr= data[@"nonceStr"];
    NSString* timeStamp=data[@"timeStamp"];
    request.timeStamp= [timeStamp intValue];
    request.sign= data[@"sign"];
    return request;
}

NSDictionary* respToData(BaseResp* resp){
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([resp class], &count);

    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[resp valueForKey:key] forKey:key];
    }

    free(properties);
    return [NSDictionary dictionaryWithDictionary:dict];
}

@interface SoWechatPlugin() <FlutterStreamHandler, UIApplicationDelegate, WXApiDelegate>
@property (copy, nonatomic)   FlutterEventSink   flutterEventSink;
@end

@implementation SoWechatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"com.github.taojoe.so_wechat/method" binaryMessenger:[registrar messenger]];
    FlutterEventChannel* stream = [FlutterEventChannel eventChannelWithName:@"com.github.taojoe.so_wechat/stream" binaryMessenger:registrar.messenger];
    SoWechatPlugin* instance = [[SoWechatPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [stream setStreamHandler:instance];
    [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"method call0");
    NSString* sendPrefix=@"send";
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
            NSLog(@"method call1");
        BOOL isWeChatRegistered = [WXApi registerApp:appId universalLink:universalLink];
            NSLog(@"method call2");
        result(@(isWeChatRegistered));
    } else if([call.method hasPrefix:sendPrefix]){
        NSLog(@"method call send 0");
        NSString* name=[call.method substringFromIndex:sendPrefix.length];
        NSLog(@"method call send 1");
        NSLog(name);
        NSLog(@"method call send 2");
        BaseReq* request=dataToReq(name, call.arguments);
        NSLog(@"method call send 3");
        [WXApi sendReq:request completion:^(BOOL success) {
            result([NSNumber numberWithBool:true]);
        }];
        NSLog(@"method call send 4");
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (void)onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[PayResp class]]){
        if(self.flutterEventSink!=nil){
            self.flutterEventSink(respToData(resp));
        }
    }
}

@end
