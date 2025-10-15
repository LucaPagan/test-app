//
//  AppConfig.swift
//  StarMap
//
//  Created by Francesco Albano on 10/07/25.
//

import Foundation
import CoreGraphics

/// Defines global configurations and tuning parameters for the application.
struct AppConfig {
    static let defaultFieldOfView: Double = 60.0
    static let minimumFieldOfView: Double = 10.0
    static let maximumFieldOfView: Double = 60.0
    static let motionUpdateInterval: TimeInterval = 1.0 / 60.0
    static let selectionTapRadius: Double = 50.0
    static let renderingBuffer: Double = 50.0
    static let brightStarGlowThreshold: Double = 3.0
    static let dragSensitivity: Double = 0.01
}
