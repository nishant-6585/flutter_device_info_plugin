import 'package:flutter_device_info_plugin/model/base_device_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_info_plugin/flutter_device_info_plugin.dart';
import 'package:flutter_device_info_plugin/flutter_device_info_plugin_platform_interface.dart';
import 'package:flutter_device_info_plugin/flutter_device_info_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDeviceInfoPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterDeviceInfoPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<BaseDeviceInfo?> deviceInfo() {
    // TODO: implement deviceInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> hasPhonePermission() {
    // TODO: implement hasPhonePermission
    throw UnimplementedError();
  }

  @override
  Future<void> requestPhonePermission() {
    // TODO: implement requestPhonePermission
    throw UnimplementedError();
  }
}

void main() {
  final FlutterDeviceInfoPluginPlatform initialPlatform = FlutterDeviceInfoPluginPlatform.instance;

  test('$MethodChannelFlutterDeviceInfoPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterDeviceInfoPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterDeviceInfoPlugin flutterDeviceInfoPlugin = FlutterDeviceInfoPlugin();
    MockFlutterDeviceInfoPluginPlatform fakePlatform = MockFlutterDeviceInfoPluginPlatform();
    FlutterDeviceInfoPluginPlatform.instance = fakePlatform;

   // expect(await flutterDeviceInfoPlugin.getPlatformVersion(), '42');
  });
}
