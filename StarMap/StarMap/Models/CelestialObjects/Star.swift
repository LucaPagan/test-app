//
//  Star.swift
//  StarMap
//
//  Created by Francesco Albano on 10/08/25.
//

import SwiftUI

/// A model representing a star in the sky.
struct Star: CelestialObject {
    let id = UUID()
    let name: String
    let position: CartesianCoordinates
    let brightness: Float
    let size: Float
    let color: (r: Float, g: Float, b: Float)
    let spectralClass: String
    
    var primaryColor: Color {
        Color(red: Double(color.r), green: Double(color.g), blue: Double(color.b))
    }
    
    var typeName: String { "Star" }
    
    var details: [String: String] {
        ["Spectral Class": spectralClass, "Brightness": String(format: "%.1f%%", brightness * 100)]
    }
}
