//
//  MotionDetector.swift
//  LevelApp
//
//  Created by Yury Shalin on 24.12.2024.
//

import CoreMotion

class MotionDetector {
    private let motionManager = CMMotionManager()
    private var updateInterval: TimeInterval
    
    var deviceRoll: Double = 0
    var rollInclinationReference: Double = 0
    
    var onUpdate: (() -> Void) = {}
    
    init(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
    }
    
    deinit {
        stop()
    }
    
    func start() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] motion, error in
            guard let self, let motion else { return }
            updateMotionData(motion: motion)
        }
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func started() -> MotionDetector {
        start()
        return self
    }
    
    func fixInclinationReference() {
        rollInclinationReference = deviceRoll
    }
    
    func resetInclincationReference() {
        rollInclinationReference = 0
    }
}

private extension MotionDetector {
    func updateMotionData(motion: CMDeviceMotion) {
        let xGravity = motion.gravity.x
        let yGravity = motion.gravity.y
            
        let theta = atan2(xGravity, yGravity)
        deviceRoll = (theta - .pi) * -1
        
//        print("theta: \(theta * (180.0 / .pi)), deviceRollAngle: \(deviceRoll * (180.0 / .pi))")
        
        onUpdate()
    }
}
