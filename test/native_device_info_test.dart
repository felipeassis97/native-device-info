import 'package:flutter_test/flutter_test.dart';
import 'package:native_device_info/native_device_info.dart';
import 'package:native_device_info/native_device_info_platform_interface.dart';
import 'package:native_device_info/native_device_info_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeDeviceInfoPlatform
    with MockPlatformInterfaceMixin
    implements NativeDeviceInfoPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NativeDeviceInfoPlatform initialPlatform = NativeDeviceInfoPlatform.instance;

  test('$MethodChannelNativeDeviceInfo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeDeviceInfo>());
  });

  test('getPlatformVersion', () async {
    NativeDeviceInfo nativeDeviceInfoPlugin = NativeDeviceInfo();
    MockNativeDeviceInfoPlatform fakePlatform = MockNativeDeviceInfoPlatform();
    NativeDeviceInfoPlatform.instance = fakePlatform;

    expect(await nativeDeviceInfoPlugin.getPlatformVersion(), '42');
  });
}
