import Flutter
import UIKit

enum DeviceInfoChannelNames {
  static let methodChannel = "native_device_info/method"
  static let eventChannel = "native_device_info/event"
}

class BatteryStateManager {
  static func monitorBatteryState(eventSink: @escaping FlutterEventSink) {
    UIDevice.current.isBatteryMonitoringEnabled = true
    sendBatteryStateEvent(eventSink: eventSink)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onBatteryStateDidChange),
      name: UIDevice.batteryStateDidChangeNotification,
      object: nil)
  }

  @objc private static func onBatteryStateDidChange(notification: NSNotification) {
    guard let eventSink = NativeDeviceInfoPlugin().eventSink else { return }
    sendBatteryStateEvent(eventSink: eventSink)
  }

  static func stopMonitoringBatteryState() {
    NotificationCenter.default.removeObserver(self)
    UIDevice.current.isBatteryMonitoringEnabled = false
  }

  private static func sendBatteryStateEvent(eventSink: FlutterEventSink) {
    let state = UIDevice.current.batteryState
    switch state {
    case .charging:
      eventSink("charging")
    case .full:
      eventSink("full")
    case .unplugged:
      eventSink("unplugged")
    default:
      eventSink(
        FlutterError(
          code: "UNAVAILABLE", message: "Charging status unavailable", details: nil))
    }
  }
}

class PlatformInfoManager {
  static func getPlatformVersion(result: FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  static func getBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    guard device.batteryState != .unknown else {
      result(
        FlutterError(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil)
      )
      return
    }
    result(Int(device.batteryLevel * 100))
  }
}

public class NativeDeviceInfoPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  var eventSink: FlutterEventSink?

  // Register method and event channels
  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: DeviceInfoChannelNames.methodChannel, binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: DeviceInfoChannelNames.eventChannel, binaryMessenger: registrar.messenger())

    let instance = NativeDeviceInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
  }

  // Handle method calls
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      PlatformInfoManager.getPlatformVersion(result: result)
    case "getBatteryLevel":
      PlatformInfoManager.getBatteryLevel(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // Handle EventChannel for battery state
  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink)
    -> FlutterError?
  {
    self.eventSink = eventSink
    BatteryStateManager.monitorBatteryState(eventSink: eventSink)
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    BatteryStateManager.stopMonitoringBatteryState()
    eventSink = nil
    return nil
  }
}
