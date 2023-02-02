#import "TinkoffIdFlutterPlugin.h"
#if __has_include(<tinkoff_id_flutter/tinkoff_id_flutter-Swift.h>)
#import <tinkoff_id_flutter/tinkoff_id_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tinkoff_id_flutter-Swift.h"
#endif

@implementation TinkoffIdFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTinkoffIdFlutterPlugin registerWithRegistrar:registrar];
}
@end
