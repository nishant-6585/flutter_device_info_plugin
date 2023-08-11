package com.zensar.plugin.flutter_device_info_plugin

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.FeatureInfo
import android.content.pm.PackageManager
import android.os.Build
import android.util.DisplayMetrics
import android.view.Display
import android.view.WindowManager
import androidx.annotation.NonNull
import android.telephony.TelephonyManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterDeviceInfoPlugin */
class FlutterDeviceInfoPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private val MY_PERMISSIONS_REQUEST_READ_PHONE_STATE = 0

  private lateinit var permissionEvent: EventChannel.EventSink
  private lateinit var channel : MethodChannel
  private lateinit var permissionEventChannel: EventChannel

  lateinit var packageManager: PackageManager
  lateinit var windowManager: WindowManager
  lateinit var applicationContext: Context
  lateinit var activity: Activity
  private lateinit var result: Result

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_device_info_plugin")
    channel.setMethodCallHandler(this)
    applicationContext = flutterPluginBinding.applicationContext
    packageManager = flutterPluginBinding.applicationContext.packageManager
    windowManager= flutterPluginBinding.applicationContext.getSystemService(Context.WINDOW_SERVICE) as WindowManager

    permissionEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "phone_permission_event")
    permissionEventChannel.setStreamHandler(object : EventChannel.StreamHandler {

      override fun onListen(o: Any, eventSink: EventChannel.EventSink) {
        permissionEvent = eventSink
      }

      override fun onCancel(o: Any?) {
      }
    })
  }
  override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
    activity = activityPluginBinding.getActivity()
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }
  override fun onDetachedFromActivity() {
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    this.result = result
    val methodHasPhonePermission = "hasPhonePermission"
    val methodDeviceInfo = "deviceInfo"
    val methodRequestPhonePermission = "requestPhonePermission"

    when(call.method) {
      methodHasPhonePermission -> {
        val build: MutableMap<String, Any> = HashMap()
        result.success(hasPhonePermission())
      }
      methodRequestPhonePermission -> {
        requestPhonePermission()
      }
      methodDeviceInfo -> {
        getDeviceInfo()
      }
      else -> result.notImplemented()
    }
  }

  private fun hasPhonePermission(): Boolean {
    return if (android.os.Build.VERSION.SDK_INT > Build.VERSION_CODES.Q) {
      ContextCompat.checkSelfPermission(
        applicationContext,
        Manifest.permission.READ_PHONE_NUMBERS
      ) === PackageManager.PERMISSION_GRANTED
    } else {
      ContextCompat.checkSelfPermission(
        applicationContext,
        Manifest.permission.READ_PHONE_STATE
      ) === PackageManager.PERMISSION_GRANTED
    }
  }

  private fun requestPhonePermission() {
    if (android.os.Build.VERSION.SDK_INT > Build.VERSION_CODES.Q) {
      if (ActivityCompat.shouldShowRequestPermissionRationale(activity,
          Manifest.permission.READ_PHONE_NUMBERS)) {

      } else {
        ActivityCompat.requestPermissions(activity,
          arrayOf<String>(Manifest.permission.READ_PHONE_NUMBERS), MY_PERMISSIONS_REQUEST_READ_PHONE_STATE);
      }
    } else {
      if (ActivityCompat.shouldShowRequestPermissionRationale(activity,
          Manifest.permission.READ_PHONE_STATE)) {
      } else {
        ActivityCompat.requestPermissions(activity,
          arrayOf<String>(Manifest.permission.READ_PHONE_STATE), MY_PERMISSIONS_REQUEST_READ_PHONE_STATE);
      }
    }
  }

  @Override
  fun onRequestPermissionsResult(
    requestCode: Int, @NonNull permissions: Array<String?>?,
    @NonNull grantResults: IntArray
  ): Boolean {
    // If request is cancelled, the result arrays are empty.
    if (requestCode == MY_PERMISSIONS_REQUEST_READ_PHONE_STATE) {
      if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        if (permissionEvent != null) permissionEvent.success(true)
        //generateMobileNumber()
        result.success(true)
        return true
      } else {
        if (permissionEvent != null) permissionEvent.success(false)
      }
    }
    result.error("PERMISSION", "onRequestPermissionsResult is not granted", null)
    return false
  }

  private fun getDeviceInfo() {
    val build: MutableMap<String, Any> = HashMap()
    build["board"] = Build.BOARD
    build["bootloader"] = Build.BOOTLOADER
    build["brand"] = Build.BRAND
    build["device"] = Build.DEVICE
    build["display"] = Build.DISPLAY
    build["fingerprint"] = Build.FINGERPRINT
    build["hardware"] = Build.HARDWARE
    build["host"] = Build.HOST
    build["id"] = Build.ID
    build["manufacturer"] = Build.MANUFACTURER
    build["model"] = Build.MODEL
    build["product"] = Build.PRODUCT

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      build["supported32BitAbis"] = listOf(*Build.SUPPORTED_32_BIT_ABIS)
      build["supported64BitAbis"] = listOf(*Build.SUPPORTED_64_BIT_ABIS)
      build["supportedAbis"] = listOf<String>(*Build.SUPPORTED_ABIS)
    } else {
      build["supported32BitAbis"] = emptyList<String>()
      build["supported64BitAbis"] = emptyList<String>()
      build["supportedAbis"] = emptyList<String>()
    }

    build["tags"] = Build.TAGS
    build["type"] = Build.TYPE
    build["isPhysicalDevice"] = !isEmulator
    build["systemFeatures"] = getSystemFeatures()

    val version: MutableMap<String, Any> = HashMap()
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      version["baseOS"] = Build.VERSION.BASE_OS
      version["previewSdkInt"] = Build.VERSION.PREVIEW_SDK_INT
      version["securityPatch"] = Build.VERSION.SECURITY_PATCH
    }
    version["codename"] = Build.VERSION.CODENAME
    version["incremental"] = Build.VERSION.INCREMENTAL
    version["release"] = Build.VERSION.RELEASE
    version["sdkInt"] = Build.VERSION.SDK_INT
    build["version"] = version

    val display: Display = windowManager.defaultDisplay
    val metrics = DisplayMetrics()
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      display.getRealMetrics(metrics)
    } else {
      display.getMetrics(metrics)
    }

    val displayResult: MutableMap<String, Any> = HashMap()
    displayResult["widthPx"] = metrics.widthPixels.toDouble()
    displayResult["heightPx"] = metrics.heightPixels.toDouble()
    displayResult["xDpi"] = metrics.xdpi
    displayResult["yDpi"] = metrics.ydpi
    build["displayMetrics"] = displayResult

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      build["serialNumber"] = try {
        Build.getSerial()
      } catch (ex: SecurityException) {
        Build.UNKNOWN
      }
    } else {
      build["serialNumber"] = Build.SERIAL
    }
    val tMgr: TelephonyManager =
      applicationContext.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    build["countryiso"] = tMgr.getSimCountryIso()
    build["simOperatorName"] = tMgr.getSimOperatorName()

    val simState = tMgr.getSimState()
    when(simState) {
      0 -> build["simState"] = "SIM_STATE_UNKNOWN"
      1 -> build["simState"] = "SIM_STATE_ABSENT"
      2 -> build["simState"] = "SIM_STATE_PIN_REQUIRED"
      3 -> build["simState"] = "SIM_STATE_PUK_REQUIRED"
      4 -> build["simState"] = "SIM_STATE_NETWORK_LOCKED"
      5 -> build["simState"] = "SIM_STATE_READY"
      6 -> build["simState"] = "SIM_STATE_NOT_READY"
      7 -> build["simState"] = "SIM_STATE_PERM_DISABLED"
      8 -> build["simState"] = "SIM_STATE_CARD_IO_ERROR"
      9 -> build["simState"] = "SIM_STATE_CARD_RESTRICTED"
      else ->  build["simState"] = "SIM_STATE_UNKNOWN"
    }

    //Log.d("Nishant", "SimSerialNumber(): ${tMgr.getSimSerialNumber()}")
    //Log.d("Nishant", "countryiso: ${tMgr.getSimCountryIso()}")
    //Log.d("Nishant", "simOperator: ${tMgr.getSimOperator()}")
    //Log.d("Nishant", "simOperatorName: ${tMgr.getSimOperatorName()}")
    //Log.d("Nishant", "simState: ${tMgr.getSimState()}")
    //Log.d("Nishant", "subscriberID: ${tMgr.getSubscriberId()}")


    result.success(build)
  }

  /**
   * A simple emulator-detection based on the flutter tools detection logic and a couple of legacy
   * detection systems
   */
  private val isEmulator: Boolean
    get() = ((Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
            || Build.FINGERPRINT.startsWith("generic")
            || Build.FINGERPRINT.startsWith("unknown")
            || Build.HARDWARE.contains("goldfish")
            || Build.HARDWARE.contains("ranchu")
            || Build.MODEL.contains("google_sdk")
            || Build.MODEL.contains("Emulator")
            || Build.MODEL.contains("Android SDK built for x86")
            || Build.MANUFACTURER.contains("Genymotion")
            || Build.PRODUCT.contains("sdk")
            || Build.PRODUCT.contains("vbox86p")
            || Build.PRODUCT.contains("emulator")
            || Build.PRODUCT.contains("simulator"))

  private fun getSystemFeatures(): List<String> {
    val featureInfos: Array<FeatureInfo> = packageManager.systemAvailableFeatures
    return featureInfos
      .filterNot { featureInfo -> featureInfo.name == null }
      .map { featureInfo -> featureInfo.name }
  }
}
