//
//  PlatformInfoManager.swift
//  Pods
//
//  Created by Felipe Assis on 15/10/2024.
//

import UIKit
import Flutter

enum PlatformChannelNames {
    static let platformMethodChannel = "native_device_info/event/platform"
}

//MARK: - Monitor connection
class PlatformInfoManager {
    init(registrar: FlutterPluginRegistrar, plugin: NativeDeviceInfoPlugin) {
        let methodChannel: FlutterMethodChannel = FlutterMethodChannel(
            name: PlatformChannelNames.platformMethodChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(plugin, channel: methodChannel)
    }
    
    static func getPlatformVersion(result: FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}
