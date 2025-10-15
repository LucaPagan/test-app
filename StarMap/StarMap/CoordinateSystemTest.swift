//
//  CoordinateSystemTest.swift
//  StarMap
//
//  Created by Luca Pagano on 13/10/25.
//


import Foundation
import SwiftUI
import SwissEphemeris

/// Temporary diagnostic tool to verify coordinate alignment
struct CoordinateSystemTest {
    
    /// Test known celestial objects to verify coordinate transformation
    static func runDiagnostics() {
        print("\n🔍 === COORDINATE SYSTEM DIAGNOSTICS ===")
        
        // Test 1: Polaris (North Star) - should be near Dec=+90°
        testStar(name: "Polaris", ra: 37.95, dec: 89.26)
        
        // Test 2: Sirius (brightest star)
        testStar(name: "Sirius", ra: 101.29, dec: -16.72)
        
        // Test 3: Vega (summer triangle)
        testStar(name: "Vega", ra: 279.23, dec: 38.78)
        
        // Test 4: Check a planet (Sun at a specific test date)
        if let sunCoords = SwissEphemerisUtils.getEquatorialCoordinates(
            for: .sun,
            at: Date()
        ) {
            print("\n☀️ Sun (current):")
            testStar(name: "Sun", ra: sunCoords.ra, dec: sunCoords.dec)
        }
        
        print("\n=== END DIAGNOSTICS ===\n")
    }
    
    private static func testStar(name: String, ra: Double, dec: Double) {
        // Convert to Cartesian
        let cartesian = AstroCalculator.equatorialToCartesian(ra: ra, dec: dec)
        
        // Apply rotation
        let rotationAngle = Double.pi / 2
        let rotatedY = cartesian.y * cos(rotationAngle) - cartesian.z * sin(rotationAngle)
        let rotatedZ = cartesian.y * sin(rotationAngle) + cartesian.z * cos(rotationAngle)
        let rotated = CartesianCoordinates(x: cartesian.x, y: rotatedY, z: rotatedZ)
        
        // Apply specular inversion
        let final = CartesianCoordinates(x: -rotated.x, y: rotated.y, z: rotated.z)
        
        print("\n⭐️ \(name):")
        print("  Input: RA=\(String(format: "%.2f", ra))° Dec=\(String(format: "%.2f", dec))°")
        print("  Cartesian: x=\(String(format: "%.3f", cartesian.x)), y=\(String(format: "%.3f", cartesian.y)), z=\(String(format: "%.3f", cartesian.z))")
        print("  Final: x=\(String(format: "%.3f", final.x)), y=\(String(format: "%.3f", final.y)), z=\(String(format: "%.3f", final.z))")
    }
}

// USAGE: Call this in your ViewModel init or when debugging:
// CoordinateSystemTest.runDiagnostics()
