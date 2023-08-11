import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:flutter_device_info_plugin/flutter_device_info_plugin.dart';
import 'package:flutter_device_info_plugin/model/ios_device_info.dart';

void main() {
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (dynamic error, dynamic stack) {
    developer.log("Something went wrong!", error: error, stackTrace: stack);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final _flutterDeviceInfoPlugin = FlutterDeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      bool hasPermission = await FlutterDeviceInfoPlugin.hasPhonePermission;
      if (hasPermission) {
        getDeviceInfo();
      } else {
        await FlutterDeviceInfoPlugin.requestPhonePermission;
      }
    } else {
      getDeviceInfo();
    }
  }

  void getDeviceInfo() async {
    var deviceData = <String, dynamic>{};
    try {
      if (kIsWeb) {
        deviceData =
            _readWebBrowserInfo(await _flutterDeviceInfoPlugin.webBrowserInfo);
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        deviceData =
            _readAndroidBuildData(await _flutterDeviceInfoPlugin.androidInfo);

        /*deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
              _readAndroidBuildData(await _flutterDeviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
              _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
              _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
              _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, dynamic>{
            'Error:': 'Fuchsia platform isn\'t supported'
          },
      }*/
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        deviceData = _readIosDeviceInfo(await _flutterDeviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'SIM Country ISO': build.countryISO,
      'SIM Operator Name': build.simOperatorName,
      'SIM State': build.simState,
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'mobileCountryCode': data.mobileCountryCode,
      'isoCountryCode': data.carrierName,
      'carrierName': data.isoCountryCode,
      'mobileNetworkCode': data.mobileNetworkCode,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_getAppBarTitle()),
          elevation: 4,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
              itemCount: _deviceData.length,
              itemBuilder: (context, index) {
                String key = _deviceData.keys.elementAt(index);
                return Card(
                  color: Colors.green,
                  child: ListTile(
                    title: Text(
                      key,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${_deviceData[key]}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    var returnValue = "";
    if (kIsWeb) {
      returnValue = 'Web Browser info';
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          returnValue = 'Android Device Info';
          break;
        case TargetPlatform.iOS:
          returnValue = 'iOS Device Info';
          break;
        case TargetPlatform.linux:
          returnValue = 'Linux Device Info';
          break;
        case TargetPlatform.windows:
          returnValue = 'Windows Device Info';
          break;
        case TargetPlatform.macOS:
          returnValue = 'Fuchsia Device Info';
          break;
        default:
          returnValue = 'Unknown Device';
          break;
      }
    }
    return returnValue;
  }
}
