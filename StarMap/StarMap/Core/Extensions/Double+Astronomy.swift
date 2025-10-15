//
//  Double+Astronomy.swift
//  StarMap
//
//  Created by Francesco Albano on 10/08/25.
//

import Foundation

extension Double {
    var normalizedDegrees: Double {
        var normalized = self.truncatingRemainder(dividingBy: 360)
        if normalized < 0 { normalized += 360 }
        return normalized
    }
    
    var toDegrees: Double { self * 180 / .pi }
    var toRadians: Double { self * .pi / 180 }
    
    var cardinalDirectionName: String {
        let normalized = self.normalizedDegrees
        let index = Int((normalized + 22.5) / 45.0) % 8
        return Constants.cardinalDirections[index]
    }
}

extension Date {
    var julianDay: Double {
        self.timeIntervalSince1970 / 86400.0 + 2440587.5
    }
}
