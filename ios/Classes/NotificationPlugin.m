#import "NotificationPlugin.h"
#if __has_include(<notification/notification-Swift.h>)
#import <notification/notification-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notification-Swift.h"
#endif

@implementation NotificationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificationPlugin registerWithRegistrar:registrar];
}
@end
