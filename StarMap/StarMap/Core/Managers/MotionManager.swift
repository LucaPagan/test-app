//
//  MotionManager.swift
//  StarMap
//
//  Created by Francesco Albano on 10/08/25.
//

import CoreMotion
import Combine
import simd

/// Manages device motion updates using CoreMotion to track the device's orientation.
@MainActor
class MotionManager: ObservableObject {
    @Published var rotationMatrix: CMRotationMatrix = CMRotationMatrix()
    @Published var pitch: Double = 0
    @Published var yaw: Double = 0
    @Published var roll: Double = 0
    
    private let motionManager = CMMotionManager()
    
    func startTracking() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = AppConfig.motionUpdateInterval
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main) { [weak self] motion, _ in
            guard let self = self, let motion = motion else { return }
            
            self.rotationMatrix = motion.attitude.rotationMatrix
            self.pitch = motion.attitude.pitch
            self.yaw = motion.attitude.yaw
            self.roll = motion.attitude.roll
        }
    }
    
    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
    }
}
