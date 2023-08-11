import 'dart:math' as math show sqrt;
import 'base_device_info.dart';

class AndroidDeviceInfo extends BaseDeviceInfo {

  AndroidDeviceInfo._({
    required Map<String, dynamic> data,
    required this.countryISO,
    required this.simOperatorName,
    required this.simState,
    required this.version,
    required this.board,
    required this.bootloader,
    required this.brand,
    required this.device,
    required this.display,
    required this.fingerprint,
    required this.hardware,
    required this.host,
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.product,
    required List<String> supported32BitAbis,
    required List<String> supported64BitAbis,
    required List<String> supportedAbis,
    required this.tags,
    required this.type,
    required this.isPhysicalDevice,
    required List<String> systemFeatures,
    required this.displayMetrics,
    required this.serialNumber,
  })  : supported32BitAbis = List<String>.unmodifiable(supported32BitAbis),
        supported64BitAbis = List<String>.unmodifiable(supported64BitAbis),
        supportedAbis = List<String>.unmodifiable(supportedAbis),
        systemFeatures = List<String>.unmodifiable(systemFeatures),
        super(data);

  final String countryISO;
  final String simOperatorName;
  final String simState;
  final AndroidBuildVersion version;
  final String board;
  final String bootloader;
  final String brand;
  final String device;
  final String display;
  final String fingerprint;
  final String hardware;
  final String host;
  final String id;
  final String manufacturer;
  final String model;
  final String product;
  final List<String> supported32BitAbis;
  final List<String> supported64BitAbis;
  final List<String> supportedAbis;
  final String tags;
  final String type;
  final bool isPhysicalDevice;
  final List<String> systemFeatures;
  final AndroidDisplayMetrics displayMetrics;
  final String serialNumber;

  /// Deserializes from the message received from [_kChannel].
  static AndroidDeviceInfo fromMap(Map<String, dynamic> map) {
    return AndroidDeviceInfo._(
      data: map,
      countryISO: map["countryiso"],
      simOperatorName: map["simOperatorName"],
      simState: map["simState"],
      version: AndroidBuildVersion._fromMap(
          map['version']?.cast<String, dynamic>() ?? {}),
      board: map['board'],
      bootloader: map['bootloader'],
      brand: map['brand'],
      device: map['device'],
      display: map['display'],
      fingerprint: map['fingerprint'],
      hardware: map['hardware'],
      host: map['host'],
      id: map['id'],
      manufacturer: map['manufacturer'],
      model: map['model'],
      product: map['product'],
      supported32BitAbis: _fromList(map['supported32BitAbis'] ?? <String>[]),
      supported64BitAbis: _fromList(map['supported64BitAbis'] ?? <String>[]),
      supportedAbis: _fromList(map['supportedAbis'] ?? []),
      tags: map['tags'],
      type: map['type'],
      isPhysicalDevice: map['isPhysicalDevice'],
      systemFeatures: _fromList(map['systemFeatures'] ?? []),
      displayMetrics: AndroidDisplayMetrics._fromMap(
          map['displayMetrics']?.cast<String, dynamic>() ?? {}),
      serialNumber: map['serialNumber'],
    );
  }
  /// Deserializes message as List<String>
  static List<String> _fromList(List<dynamic> message) {
    final list = message.takeWhile((item) => item != null).toList();
    return List<String>.from(list);
  }
}

class AndroidBuildVersion {
  const AndroidBuildVersion._({
    this.baseOS,
    required this.codename,
    required this.incremental,
    required this.previewSdkInt,
    required this.release,
    required this.sdkInt,
    this.securityPatch,
  });

  final String? baseOS;

  final String codename;

  final String incremental;

  final int? previewSdkInt;

  final String release;

  final int sdkInt;

  final String? securityPatch;

  /// Serializes [ AndroidBuildVersion ] to map.
  @Deprecated('[toMap] method will be discontinued')
  Map<String, dynamic> toMap() {
    return {
      'baseOS': baseOS,
      'sdkInt': sdkInt,
      'release': release,
      'codename': codename,
      'incremental': incremental,
      'previewSdkInt': previewSdkInt,
      'securityPatch': securityPatch,
    };
  }

  /// Deserializes from the map message received from [_kChannel].
  static AndroidBuildVersion _fromMap(Map<String, dynamic> map) {
    return AndroidBuildVersion._(
      baseOS: map['baseOS'],
      codename: map['codename'],
      incremental: map['incremental'],
      previewSdkInt: map['previewSdkInt'],
      release: map['release'],
      sdkInt: map['sdkInt'],
      securityPatch: map['securityPatch'],
    );
  }
}

class AndroidDisplayMetrics {
  const AndroidDisplayMetrics._({
    required this.widthPx,
    required this.heightPx,
    required this.xDpi,
    required this.yDpi,
  });

  final double widthPx;

  final double heightPx;

  final double xDpi;

  final double yDpi;

  double get widthInches => widthPx / xDpi;

  double get heightInches => heightPx / yDpi;

  double get sizeInches {
    final width = widthInches;
    final height = heightInches;
    return math.sqrt((width * width) + (height * height));
  }

  /// Serializes [AndroidDisplayMetrics] to map.
  Map<String, dynamic> toMap() {
    return {
      'widthPx': widthPx,
      'heightPx': heightPx,
      'xDpi': xDpi,
      'yDpi': yDpi,
    };
  }

  /// Deserializes from the map message received from the [MethodChannel].
  static AndroidDisplayMetrics _fromMap(Map<String, dynamic> map) {
    return AndroidDisplayMetrics._(
      widthPx: map['widthPx'],
      heightPx: map['heightPx'],
      xDpi: map['xDpi'],
      yDpi: map['yDpi'],
    );
  }
}