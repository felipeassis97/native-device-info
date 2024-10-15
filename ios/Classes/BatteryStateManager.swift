//
//  BatteryManager.swift
//  Pods
//
//  Created by Felipe Assis on 15/10/2024.
//

import UIKit
import Flutter

enum BatteryChannelNames {
    static let methodChannel = "native_device_info/method/battery"
    static let eventChannel = "native_device_info/event/battery"
}

class BatteryStateManager {
    static var batteryEventSink: FlutterEventSink?
    
    init(registrar: FlutterPluginRegistrar, plugin: NativeDeviceInfoPlugin) {
        let methodChannel: FlutterMethodChannel = FlutterMethodChannel(
            name: BatteryChannelNames.methodChannel, binaryMessenger: registrar.messenger())
        
        let eventChannel = FlutterEventChannel(name: BatteryChannelNames.eventChannel, binaryMessenger: registrar.messenger())
        
        eventChannel.setStreamHandler(plugin)
        registrar.addMethodCallDelegate(plugin, channel: methodChannel)
    }
    
    //MARK: - Battery Level
    static func getBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        guard device.batteryState != .unknown else {
            result(NativeDeviceInfoError.unavailable(message: "Battery info unavailable").flutterError)
            return
        }
        result(Int(device.batteryLevel * 100))
    }
    
    
    //MARK: - Battery State Monitoring
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
        guard let eventSink = batteryEventSink else { return }
        sendBatteryStateEvent(eventSink: eventSink)
    }
    
    static func stopMonitoringBatteryState() {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
    private static func sendBatteryStateEvent(eventSink: @escaping FlutterEventSink) {
        let state = UIDevice.current.batteryState
        DispatchQueue.main.async {
            switch state {
            case .charging, .full:
                eventSink("plugged")
            case .unplugged:
                eventSink("unplugged")
            default:
                eventSink(NativeDeviceInfoError.unavailable(message: "Charging status unavailable").flutterError)
            }
        }
    }
}
