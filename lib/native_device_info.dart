import 'native_device_info_platform_interface.dart';

class NativeDeviceInfo {
  /// 📱 Get platform version
  Future<String?> getPlatformVersion() =>
      NativeDeviceInfoPlatform.instance.getPlatformVersion();

  /// 🔋 Get battery level
  Future<int?> getBatteryLevel() =>
      NativeDeviceInfoPlatform.instance.getBatteryLevel();

  /// ⚡️ Listen to charging state changes
  static Stream<String> get chargingStatus =>
      NativeDeviceInfoPlatform.instance.chargingStatus;
}
