//
//  CartesianCoordinates.swift
//  StarMap
//
//  Created by Francesco Albano on 10/08/25.
//

import Foundation
import CoreMotion
import simd

/// Represents a point in a 3D right-handed Cartesian coordinate system.
struct CartesianCoordinates {
    let x: Double
    let y: Double
    let z: Double
    
    var isVisible: Bool { z > 0 }
    
    /// Crea coordinate cartesiane da RA/Dec (J2000) - UNICO METODO
    static func fromEquatorial(ra: Double, dec: Double) -> CartesianCoordinates {
        let raRad = ra.toRadians
        let decRad = dec.toRadians
        
        // Conversione standard equatoriale → cartesiana
        let x = cos(decRad) * cos(raRad)
        let y = cos(decRad) * sin(raRad)
        let z = sin(decRad)
        
        // Rotazione di 90° per allineare il polo celeste
        let rotationAngle = Double.pi / 2
        let rotatedY = y * cos(rotationAngle) - z * sin(rotationAngle)
        let rotatedZ = y * sin(rotationAngle) + z * cos(rotationAngle)
        
        // Inversione speculare per orientamento E/W corretto
        return CartesianCoordinates(x: -x, y: rotatedY, z: rotatedZ)
    }
    
    func rotatedByDeviceMatrix(_ matrix: CMRotationMatrix) -> CartesianCoordinates {
        // Calibrazione per allineare Nord gyroscopio con -Z
        let yawCorrection = -Double.pi / 2
        let cosYaw = cos(yawCorrection)
        let sinYaw = sin(yawCorrection)
        
        let calibratedX = x * cosYaw - z * sinYaw
        let calibratedZ = x * sinYaw + z * cosYaw
        let calibratedY = y
        
        // Adattamento portrait
        let portraitX = calibratedX
        let portraitY = calibratedZ
        let portraitZ = -calibratedY
        
        // Applicazione matrice device
        let newX = -(matrix.m11 * portraitX + matrix.m12 * portraitY + matrix.m13 * portraitZ)
        let newY = -(matrix.m21 * portraitX + matrix.m22 * portraitY + matrix.m23 * portraitZ)
        let newZ = matrix.m31 * portraitX + matrix.m32 * portraitY + matrix.m33 * portraitZ
        
        return CartesianCoordinates(x: newX, y: newY, z: newZ)
    }
    
    func rotated(pitch: Double, yaw: Double) -> CartesianCoordinates {
        // Rotazione yaw (asse Y)
        let cosYaw = cos(-yaw)
        let sinYaw = sin(-yaw)
        let x1 = x * cosYaw - z * sinYaw
        let z1 = x * sinYaw + z * cosYaw
        
        // Rotazione pitch (asse X)
        let cosPitch = cos(-pitch)
        let sinPitch = sin(-pitch)
        let y2 = y * cosPitch - z1 * sinPitch
        let z2 = y * sinPitch + z1 * cosPitch
        
        return CartesianCoordinates(x: x1, y: y2, z: z2)
    }
}

