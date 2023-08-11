#include "include/flutter_device_info_plugin/flutter_device_info_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_device_info_plugin.h"

void FlutterDeviceInfoPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_device_info_plugin::FlutterDeviceInfoPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
