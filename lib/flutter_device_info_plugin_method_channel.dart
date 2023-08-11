import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_device_info_plugin_platform_interface.dart';
import 'model/base_device_info.dart';

/// An implementation of [FlutterDeviceInfoPluginPlatform] that uses method channels.
class MethodChannelFlutterDeviceInfoPlugin extends FlutterDeviceInfoPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_device_info_plugin');

  // Generic method channel for all devices
  @override
  Future<BaseDeviceInfo> deviceInfo() async {
    return BaseDeviceInfo(
        (await methodChannel.invokeMethod('deviceInfo')).cast<String, dynamic>());
  }

  @override
  Future<bool> hasPhonePermission() async {
    final bool hasPermission = await methodChannel.invokeMethod('hasPhonePermission');
    return hasPermission;
  }

  @override
  Future<void> requestPhonePermission() async {
    await methodChannel.invokeMethod('requestPhonePermission');
  }
}
