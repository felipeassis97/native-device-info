import UIKit
import Flutter

public class NativeDeviceInfoPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    //MARK: Setup features
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = NativeDeviceInfoPlugin()
        
        let _ = PlatformInfoManager(registrar: registrar, plugin: instance)
        let _ = BatteryStateManager(registrar: registrar, plugin: instance)
        let _ = ConnectionStateManager(registrar: registrar, plugin: instance)
    }
    
    //MARK: Handle method channel calls
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            PlatformInfoManager.getPlatformVersion(result: result)
        case "getBatteryLevel":
            BatteryStateManager.getBatteryLevel(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        guard let channel = arguments as? String else {
            return NativeDeviceInfoError.invalidArguments.flutterError
        }
        
        switch channel {
        case "battery":
            BatteryStateManager.batteryEventSink = eventSink
            BatteryStateManager.monitorBatteryState(eventSink: eventSink)
            return nil
        case "connection":
            ConnectionStateManager.connectionEventSink = eventSink
            ConnectionStateManager.monitorConnectionState(eventSink: eventSink)
            return nil
        default:
            return NativeDeviceInfoError.unknownChannel.flutterError
        }
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if BatteryStateManager.batteryEventSink != nil {
            BatteryStateManager.stopMonitoringBatteryState()
            BatteryStateManager.batteryEventSink = nil
        }
        
        if ConnectionStateManager.connectionEventSink != nil {
            ConnectionStateManager.stopMonitoringConnectionState()
            ConnectionStateManager.connectionEventSink = nil
        }
        return nil
    }
}
