import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_device_info_platform_interface.dart';

/// An implementation of [NativeDeviceInfoPlatform] that uses method channels.
class MethodChannelNativeDeviceInfo extends NativeDeviceInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_device_info/method');
  final eventChannel = const EventChannel('native_device_info/event');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> getBatteryLevel() async {
    final battery = await methodChannel.invokeMethod<int>('getBatteryLevel');
    return battery;
  }

  @override
  Stream<String> get chargingStatus {
    return eventChannel
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }
}
