//
//  ViewController.swift
//  LevelApp
//
//  Created by Yury Shalin on 23.12.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var horizonIndicatorView: HorizonIndicatorView!
    private var motionDetector: MotionDetector!
    private var rollZeroReference: Double = 0 //.pi / 2
    private var zeroReferenceLocked: Bool = false
    
    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var zeroRefLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizonIndicatorView = HorizonIndicatorView(frame: CGRect(origin: .zero, size: .init(width: view.bounds.width, height: view.bounds.width)))
        view.addSubview(horizonIndicatorView)
        
        horizonIndicatorView.center = view.center
        
        horizonIndicatorView.backgroundColor = .green //.black
        
        startMotionMonitoring()
    }

    @IBAction func fixTapped(_ sender: Any) {
        horizonIndicatorView.zeroReferenceLocked = true
        zeroReferenceLocked = true
        rollZeroReference = motionDetector.deviceRoll
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        horizonIndicatorView.zeroReferenceLocked = false
        zeroReferenceLocked = false
        rollZeroReference = 0
    }
    
}

private extension ViewController {
    func startMotionMonitoring() {
        motionDetector = MotionDetector(updateInterval: 0.01)
        motionDetector.onUpdate = { [weak self] in
            guard let self else { return }
            handleMotionUpdate()
//            horizonIndicatorView.rotation = motionDetector.deviceRoll
//            horizonIndicatorView.zeroReference = rollZeroReference
        }
        
        motionDetector.start()
    }
    
    func handleMotionUpdate() {
        
        rollZeroReference = calculateZeroReference(absoluteRoll: motionDetector.deviceRoll, zeroReference: rollZeroReference)
        
        horizonIndicatorView.rotation = motionDetector.deviceRoll
//        horizonIndicatorView.zeroReference = rollZeroReference
        horizonIndicatorView.zeroReference = rollZeroReference
        
        rollLabel.text = "Roll: \(Int(motionDetector.deviceRoll.toDeg))"
        zeroRefLabel.text = "Zero ref: \(Int(rollZeroReference.toDeg))"
    }
    
    func calculateZeroReference(absoluteRoll: Double, zeroReference: Double) -> Double {
        guard zeroReferenceLocked == false else { return zeroReference}
        
        var nextZeroRef: Double = 0
        var relativeRoll = absoluteRoll - zeroReference
        if relativeRoll > .pi / 2 {
            relativeRoll = relativeRoll - 360.toRad
        }
        
        if relativeRoll > 0 {
            nextZeroRef = zeroReference + 90.toRad
            if nextZeroRef - absoluteRoll < 20.toRad {
                if nextZeroRef > .pi + .pi / 2 {
                    return 0
                } else {
                    return nextZeroRef
                }
            }
        } else {
            nextZeroRef = zeroReference - 90.toRad
            if nextZeroRef < 0 {
                nextZeroRef = nextZeroRef + 360.toRad
            }
            
            if absoluteRoll - nextZeroRef < 20.toRad {
                return nextZeroRef
            }
        }
     
        return zeroReference
    }
}

public extension Double {
    var toDeg: Double {
        self * 180 / .pi
    }
    
    var toRad: Double {
        self * .pi / 180
    }
}

