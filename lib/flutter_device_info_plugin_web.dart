import 'package:flutter_device_info_plugin/flutter_device_info_plugin_platform_interface.dart';
import 'dart:html' as html show window, Navigator;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'model/base_device_info.dart';
import 'model/web_browser_info.dart';

class FlutterDeviceInfoPluginWeb extends FlutterDeviceInfoPluginPlatform {

  final html.Navigator _navigator;

  /// Constructs a DeviceInfoPlusPlugin.
  FlutterDeviceInfoPluginWeb(navigator) : _navigator = navigator;

  /// Factory method that initializes the FlutterDeviceInfo plugin platform
  /// with an instance of the plugin for the web.
  static void registerWith(Registrar registrar) {
    FlutterDeviceInfoPluginPlatform.instance =
        FlutterDeviceInfoPluginWeb(html.window.navigator);
  }

  @override
  Future<BaseDeviceInfo> deviceInfo() {
    return Future<WebBrowserInfo>.value(
         WebBrowserInfo.fromMap(
           {
             'appCodeName': _navigator.appCodeName,
             'appName': _navigator.appName,
             'appVersion': _navigator.appVersion,
             'deviceMemory': _navigator.deviceMemory,
             'language': _navigator.language,
             'languages': _navigator.languages,
             'platform': _navigator.platform,
             'product': _navigator.product,
             'productSub': _navigator.productSub,
             'userAgent': _navigator.userAgent,
             'vendor': _navigator.vendor,
             'vendorSub': _navigator.vendorSub,
             'hardwareConcurrency': _navigator.hardwareConcurrency,
             'maxTouchPoints': _navigator.maxTouchPoints,
           },
         ),
     );
  }
}