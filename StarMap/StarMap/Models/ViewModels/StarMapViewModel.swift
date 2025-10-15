//
//  StarMapViewModel.swift
//  StarMap
//
//  Created by Francesco Albano on 10/08/25.
//  REVISED on 15/10/25 for coordinate system correction.
//

import SwiftUI
import Combine
import CoreMotion
import CoreLocation
import SwissEphemeris

@MainActor
class StarMapViewModel: ObservableObject {
    @Published var fieldOfView: Double = AppConfig.defaultFieldOfView
    @Published var isTrackingMode: Bool = true
    @Published var selectedObject: (any CelestialObject)?
    @Published var showObjectInfo: Bool = false
    @Published var activeFilter: FilterType = .all
    @Published var planets: [Planet] = []
    @Published var manualPitch: Double = 0
    @Published var manualYaw: Double = 0
    
    let stars: [Star]
    
    private var lastDragTranslation: CGSize = .zero
    private var lastMagnification: CGFloat = 1.0
    private var lastUpdateTime: Date?
    
    var filteredObjects: [any CelestialObject] {
        switch activeFilter {
        case .all: return stars + planets
        case .stars: return stars
        case .planets: return planets
        }
    }
    
    init() {
        JPLFileManager.setEphemerisPath()
        self.stars = StarDataLoader.loadStaticStars(maxMagnitude: 6.5)
        print("✅ Loaded \(stars.count) stars")
    }
    
    /// Aggiorna i pianeti (chiamato automaticamente ogni 60s o al cambio app)
    func updatePlanets() {
        let now = Date()
        
        if let lastTime = lastUpdateTime, now.timeIntervalSince(lastTime) < 60 {
            return // Skip se meno di 60 secondi
        }
        
        print("🔄 Updating planets for \(now)")
        self.planets = PlanetProvider.createPlanets(for: now)
        self.lastUpdateTime = now
    }
    
    func forceRefresh() {
        lastUpdateTime = nil
    }
    
    // Gesture handlers
    func handleDrag(translation: CGSize, motion: MotionManager, location: LocationManager) {
        if isTrackingMode {
            isTrackingMode = false
            manualPitch = motion.pitch
            manualYaw = location.compassHeading.toRadians
        }
        
        let deltaX = translation.width - lastDragTranslation.width
        let deltaY = translation.height - lastDragTranslation.height
        
        manualYaw -= deltaX * AppConfig.dragSensitivity
        manualPitch += deltaY * AppConfig.dragSensitivity
        
        lastDragTranslation = translation
    }
    
    func endDrag() { lastDragTranslation = .zero }
    
    func handleZoom(magnification: CGFloat) {
        let delta = magnification / lastMagnification
        lastMagnification = magnification
        fieldOfView /= delta
        fieldOfView = max(AppConfig.minimumFieldOfView, min(AppConfig.maximumFieldOfView, fieldOfView))
    }
    
    func endZoom() { lastMagnification = 1.0 }
    func resumeTracking() { withAnimation { isTrackingMode = true } }
    
    func findClosestObject(at location: CGPoint, matrix: CMRotationMatrix?, pitch: Double, yaw: Double, screenSize: CGSize) -> (any CelestialObject)? {
        let centerX = screenSize.width / 2
        let centerY = screenSize.height / 2
        let scale = screenSize.width / (2 * tan(fieldOfView.toRadians / 2))
        
        var closestObject: (any CelestialObject)?
        var minDistance: Double = AppConfig.selectionTapRadius
        
        for obj in filteredObjects {
            let rotated: CartesianCoordinates
            if let matrix = matrix, isTrackingMode {
                rotated = obj.position.rotatedByDeviceMatrix(matrix)
            } else {
                rotated = obj.position.rotated(pitch: pitch, yaw: yaw)
            }
            
            if let projected = SkyRenderer.project(coordinates: rotated, screenCenter: CGPoint(x: centerX, y: centerY), scale: scale) {
                let distance = hypot(projected.x - location.x, projected.y - location.y)
                if distance < minDistance {
                    minDistance = distance
                    closestObject = obj
                }
            }
        }
        return closestObject
    }
    
    func selectObject(_ object: any CelestialObject) {
        selectedObject = object
        showObjectInfo = true
    }
    
    func deselectObject() {
        withAnimation { showObjectInfo = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.selectedObject = nil }
    }
}
