//
//  SwissEphemerisUtils.swift
//  StarMap
//
//  Created by Luca Pagano on 10/12/25.
//

import Foundation
import SwissEphemeris
import CSwissEphemeris

/// A utility enum for interacting with the Swiss Ephemeris C library.
enum SwissEphemerisUtils {
    /// Ottiene coordinate equatoriali J2000 per un pianeta
    static func getEquatorialCoordinates(for planet: SwissEphemeris.Planet, at date: Date) -> (ra: Double, dec: Double)? {
        let jd = date.julianDay
        var position = [Double](repeating: 0.0, count: 6)
        var error = [CChar](repeating: 0, count: 256)
        
        // CRITICAL: Usa J2000 equatoriali (come le stelle)
        let flags = SEFLG_SWIEPH | SEFLG_EQUATORIAL | SEFLG_J2000
        
        let result = swe_calc_ut(jd, Int32(planet.rawValue), flags, &position, &error)
        
        guard result >= 0 else {
            print("❌ Swiss Ephemeris Error: \(String(cString: error))")
            return nil
        }
        
        // position[0] = RA in gradi, position[1] = Dec in gradi
        return (ra: position[0], dec: position[1])
    }
    
    /// Ottiene la distanza dalla Terra in AU
    static func getDistance(for planet: SwissEphemeris.Planet, at date: Date) -> Double {
        let jd = date.julianDay
        var position = [Double](repeating: 0.0, count: 6)
        var error = [CChar](repeating: 0, count: 256)
        
        let flags = SEFLG_SWIEPH
        let result = swe_calc_ut(jd, Int32(planet.rawValue), flags, &position, &error)
        
        return result >= 0 ? position[2] : 0.0 // position[2] = distanza in AU
    }
}
