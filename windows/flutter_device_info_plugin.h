#ifndef FLUTTER_PLUGIN_FLUTTER_DEVICE_INFO_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_DEVICE_INFO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_device_info_plugin {

class FlutterDeviceInfoPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterDeviceInfoPlugin();

  virtual ~FlutterDeviceInfoPlugin();

  // Disallow copy and assign.
  FlutterDeviceInfoPlugin(const FlutterDeviceInfoPlugin&) = delete;
  FlutterDeviceInfoPlugin& operator=(const FlutterDeviceInfoPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_device_info_plugin

#endif  // FLUTTER_PLUGIN_FLUTTER_DEVICE_INFO_PLUGIN_H_
