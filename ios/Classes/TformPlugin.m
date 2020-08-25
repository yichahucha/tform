#import "TformPlugin.h"
#if __has_include(<tform/tform-Swift.h>)
#import <tform/tform-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tform-Swift.h"
#endif

@implementation TformPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTformPlugin registerWithRegistrar:registrar];
}
@end
