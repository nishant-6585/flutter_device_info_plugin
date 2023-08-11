#import "FlutterDeviceInfoPlugin.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation FlutterDeviceInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_device_info_plugin"
            binaryMessenger:[registrar messenger]];
  FlutterDeviceInfoPlugin* instance = [[FlutterDeviceInfoPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"deviceInfo" isEqualToString:call.method]) {
    UIDevice *device = [UIDevice currentDevice];
    struct utsname un;
    uname(&un);

    NSString *machine;
    if ([[self isDevicePhysical] isEqualToString:@"true"]) {
      machine = @(un.machine);
    } else {
      machine = [[NSProcessInfo processInfo]
          environment][@"SIMULATOR_MODEL_IDENTIFIER"];
    }

    // CTCarrier* tmpCTC = [[CTCarrier alloc] init];
    // NSString* mcc = [tmpCTC mobileCountryCode];
    // NSLog([NSString stringWithFormat:@"mcc = %@",mcc]);

    CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = info.subscriberCellularProvider;
    NSString *mobileCountryCode = carrier.mobileCountryCode;
    NSString *carrierName = carrier.carrierName;
    NSString *isoCountryCode = carrier.isoCountryCode;
    NSString *mobileNetworkCode = carrier.mobileNetworkCode;

    result(@{
      @"name" : [device name],
      @"systemName" : [device systemName],
      @"systemVersion" : [device systemVersion],
      @"model" : [device model],
      @"localizedModel" : [device localizedModel],
      @"identifierForVendor" : [[device identifierForVendor] UUIDString]
          ?: [NSNull null],
      @"isPhysicalDevice" : [self isDevicePhysical],
      @"mobileCountryCode" : [NSString stringWithFormat:@"mobileCountryCode = %@",mobileCountryCode],
      @"carrierName" : [NSString stringWithFormat:@"carrierName = %@",carrierName],
      @"isoCountryCode" : [NSString stringWithFormat:@"isoCountryCode = %@",isoCountryCode],
      @"mobileNetworkCode" : [NSString stringWithFormat:@"mobileNetworkCode = %@",mobileNetworkCode],
      @"utsname" : @{
        @"sysname" : @(un.sysname),
        @"nodename" : @(un.nodename),
        @"release" : @(un.release),
        @"version" : @(un.version),
        @"machine" : machine,
      }
    });
  } else {
    result(FlutterMethodNotImplemented);
  }
}

// return value is false if code is run on a simulator
- (NSString *)isDevicePhysical {
#if TARGET_OS_SIMULATOR
  NSString *isPhysicalDevice = @"false";
#else
  NSString *isPhysicalDevice = @"true";
#endif

  return isPhysicalDevice;
}

@end
