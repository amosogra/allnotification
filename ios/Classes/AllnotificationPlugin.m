#import "AllnotificationPlugin.h"
#if __has_include(<allnotification/allnotification-Swift.h>)
#import <allnotification/allnotification-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "allnotification-Swift.h"
#endif

@implementation AllnotificationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAllnotificationPlugin registerWithRegistrar:registrar];
}
@end
