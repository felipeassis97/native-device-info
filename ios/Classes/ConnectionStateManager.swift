//
//  ConnectionStateManager.swift
//  Pods
//
//  Created by Felipe Assis on 15/10/2024.
//

import Flutter
import Network

enum ConnectionChannelNames {
    static let eventChannel = "native_device_info/event/connection"
}

class ConnectionStateManager {
    static var monitor: NWPathMonitor?
    static var connectionEventSink: FlutterEventSink?

    init(registrar: FlutterPluginRegistrar, plugin: NativeDeviceInfoPlugin) {
        let eventChannel = FlutterEventChannel(name: ConnectionChannelNames.eventChannel, binaryMessenger: registrar.messenger())
        
        eventChannel.setStreamHandler(plugin)
    }
    
    //MARK: - Monitor connection
    static func monitorConnectionState(eventSink: @escaping FlutterEventSink) {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    eventSink("Internet connection is available.")
                } else {
                    eventSink("Internet connection is not available.")
                }
            }
        }
    }
    
    //MARK: - Stop monitor
    static func stopMonitoringConnectionState() {
        monitor?.cancel()
        monitor = nil
    }
}
