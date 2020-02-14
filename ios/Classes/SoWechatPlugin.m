#import "SoWechatPlugin.h"
#if __has_include(<so_wechat/so_wechat-Swift.h>)
#import <so_wechat/so_wechat-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "so_wechat-Swift.h"
#endif

@implementation SoWechatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSoWechatPlugin registerWithRegistrar:registrar];
}
@end
