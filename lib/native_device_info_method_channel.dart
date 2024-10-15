import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_device_info_platform_interface.dart';

/// An implementation of [NativeDeviceInfoPlatform] that uses method channels.
class MethodChannelNativeDeviceInfo extends NativeDeviceInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  //Battert
  final batteryMethodChannel =
      const MethodChannel('native_device_info/method/battery');
  final batteryEventChannel =
      const EventChannel('native_device_info/event/battery');

  //Connection
  final connectionEventChannel =
      const EventChannel('native_device_info/event/connection');

  //Platform
  final platformMethodChannel =
      const MethodChannel('native_device_info/event/platform');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await platformMethodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> getBatteryLevel() async {
    final battery =
        await batteryMethodChannel.invokeMethod<int>('getBatteryLevel');
    return battery;
  }

  @override
  Stream<String> get chargingStatus {
    return batteryEventChannel
        .receiveBroadcastStream('battery')
        .map((event) => event.toString());
  }

  @override
  Stream<String> get connectionStatus {
    return connectionEventChannel
        .receiveBroadcastStream('connection')
        .map((event) => event.toString());
  }
}
