//
//  CelestialObject.swift
//  StarMap
//
//  Created by Francesco Albano on 10/12/25.
//

import Foundation
import SwiftUI

/// A protocol representing any object that can be displayed in the sky.
protocol CelestialObject: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var position: CartesianCoordinates { get }
    var primaryColor: Color { get }
    var size: Float { get }
    var typeName: String { get }
    var details: [String: String] { get }
}

