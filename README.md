# Native Device Info Plugin

The **Native Device Info** plugin is a Flutter plugin designed to collect native device information using Method Channel and Event Channel. This plugin provides support for accessing key device data, such as battery status and monitoring whether the device is plugged into a charger.
<br>For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev), which offers tutorials,samples, guidance on mobile development, and a full API reference.

## Features

### 📱 **Battery Status**: 
- Get information about the device's battery level and charging status. Should return **int** value.
```dart
final info = NativeDeviceInfo();
final battery = await info.getBatteryLevel();
```
### 🔌 **Charger Monitoring**:
- Use an Event Channel to listen for changes in the device’s charger connection (plugged/unplugged). Should return **String** value.
```dart
NativeDeviceInfo.chargingStatus.listen(
  (status) {
    switch (status) {
      case 'plugged':
        print('Device is charging');
        break;
      case 'unplugged':
        print('Device is unplugged');
        break;
    }
  },
  onError: (error) {
    // Handle error
  },
);
```
## Installation

Add the plugin to your `pubspec.yaml` file:

```yaml
dependencies:
  native_device_info: ^0.0.1


