import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_device_info_plugin_method_channel.dart';
import 'model/base_device_info.dart';

abstract class FlutterDeviceInfoPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterDeviceInfoPluginPlatform.
  FlutterDeviceInfoPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDeviceInfoPluginPlatform _instance = MethodChannelFlutterDeviceInfoPlugin();

  /// The default instance of [FlutterDeviceInfoPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDeviceInfoPlugin].
  static FlutterDeviceInfoPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterDeviceInfoPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterDeviceInfoPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<BaseDeviceInfo?> deviceInfo() {
    throw UnimplementedError('deviceInfo() has not been implemented.');
  }

  Future<bool> hasPhonePermission() {
    throw UnimplementedError('hasPhonePermission() has not been implemented.');
  }

  Future<void> requestPhonePermission() {
    throw UnimplementedError('requestPhonePermission() has not been implemented.');
  }


}
