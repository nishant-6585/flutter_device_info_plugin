import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_info_plugin/model/ios_device_info.dart';
import 'package:flutter_device_info_plugin/widget_lifecycle.dart';
import 'flutter_device_info_plugin_platform_interface.dart';
import 'model/android_device_info.dart';
import 'model/base_device_info.dart';
import 'model/web_browser_info.dart';

export 'model/android_device_info.dart';
export 'model/web_browser_info.dart';

class FlutterDeviceInfoPlugin {
  FlutterDeviceInfoPlugin();

  static FlutterDeviceInfoPluginPlatform get _platform {
    return FlutterDeviceInfoPluginPlatform.instance;
  }

  static void listenPhonePermission(
    Function(bool isPermissionGranted) subscription,
  ) {
    WidgetsBinding.instance.addObserver(
      WidgetLifecycle(
        resumeCallBack: (() async {
          if (await FlutterDeviceInfoPlugin.hasPhonePermission) {
            subscription(true);
          } else {
            subscription(false);
          }
        }),
      ),
    );
  }

  static Future<bool> get hasPhonePermission async {
    final bool hasPermission = await _platform.hasPhonePermission();
    return hasPermission;
  }

  static Future<void> get requestPhonePermission async {
    await _platform.requestPhonePermission();
  }

  AndroidDeviceInfo? _cachedAndroidDeviceInfo;

  Future<AndroidDeviceInfo> get androidInfo async {
    _cachedAndroidDeviceInfo ??=
        AndroidDeviceInfo.fromMap((await _platform.deviceInfo())!.data);
    return _cachedAndroidDeviceInfo!;
  }

  /// This information does not change from call to call. Cache it.
  IosDeviceInfo? _cachedIosDeviceInfo;

  /// Information derived from `UIDevice`.
  ///
  /// See: https://developer.apple.com/documentation/uikit/uidevice
  Future<IosDeviceInfo> get iosInfo async {
    _cachedIosDeviceInfo ??=
        IosDeviceInfo.fromMap((await _platform.deviceInfo())!.data);
    return _cachedIosDeviceInfo!;
  }

  /// This information does not change from call to call. Cache it.
  WebBrowserInfo? _cachedWebBrowserInfo;

  /// Information derived from `Navigator`.
  Future<WebBrowserInfo> get webBrowserInfo async =>
      _cachedWebBrowserInfo ??= await _platform.deviceInfo() as WebBrowserInfo;

  /// Returns device information for the current platform.
  Future<BaseDeviceInfo?> get deviceInfo async {
    if (kIsWeb) {
      return webBrowserInfo;
    } else {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return androidInfo;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        return iosInfo;
      } /*else if (Platform.isIOS) {
        return iosInfo;
      } else if (Platform.isLinux) {
        return linuxInfo;
      } else if (Platform.isMacOS) {
        return macOsInfo;
      } else if (Platform.isWindows) {
        return windowsInfo;
      }*/
    }
    // allow for extension of the plugin
    return _platform.deviceInfo();
  }
}
