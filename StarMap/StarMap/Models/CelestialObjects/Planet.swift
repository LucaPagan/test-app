//
//  Planet.swift
//  StarMap
//
//  Created by Francesco Albano on 10/12/25.
//

import SwiftUI
import SwissEphemeris

/// A model representing a planet or other solar system body.
struct Planet: CelestialObject {
    let id = UUID()
    let name: String
    var position: CartesianCoordinates
    let body: SwissEphemeris.Planet
    let primaryColor: Color
    let size: Float
    var distanceAU: Double = 0.0
    
    var typeName: String { "Planet" }
    
    var details: [String: String] {
        ["Distance from Earth": "\(String(format: "%.2f", distanceAU)) AU"]
    }
}
