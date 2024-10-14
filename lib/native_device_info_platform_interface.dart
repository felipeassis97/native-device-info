import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_device_info_method_channel.dart';

abstract class NativeDeviceInfoPlatform extends PlatformInterface {
  /// Constructs a NativeDeviceInfoPlatform.
  NativeDeviceInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeDeviceInfoPlatform _instance = MethodChannelNativeDeviceInfo();

  /// The default instance of [NativeDeviceInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeDeviceInfo].
  static NativeDeviceInfoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeDeviceInfoPlatform] when
  /// they register themselves.
  static set instance(NativeDeviceInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> getBatteryLevel() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<String> get chargingStatus {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
