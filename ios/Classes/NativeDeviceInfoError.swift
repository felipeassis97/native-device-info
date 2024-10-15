//
//  PluginErrors.swift
//  Pods
//
//  Created by Felipe Assis on 15/10/2024.
//

import Flutter

enum NativeDeviceInfoError: Error {
    case unknownChannel
    case invalidArguments
    case unavailable(message: String)

    var flutterError: FlutterError {
        switch self {
        case .unknownChannel:
            return FlutterError(code: "UNKNOWN_CHANNEL", message: "Unknown event channel", details: nil)
        case .invalidArguments:
            return FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments missing", details: nil)
        case .unavailable(let message):
            return FlutterError(code: "UNAVAILABLE", message: message, details: nil)
        }
    }
}
