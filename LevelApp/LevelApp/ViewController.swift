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
    private var orientationZeroReference: Double = 0
    
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
        rollZeroReference = motionDetector.deviceRoll
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        horizonIndicatorView.zeroReferenceLocked = false
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
//        if (rollZeroReference + .pi / 2) - motionDetector.deviceRoll < 20.toRad{
////            rollZeroReference = rollZeroReference + .pi / 2
//            rollZeroReference = .pi / 2
//        }
        
        let roll = motionDetector.deviceRoll
//        let nextRef = rollZeroReference + .pi / 2
        var nextRef: Double = 0
        
        if roll > rollZeroReference {
            nextRef = rollZeroReference + .pi / 2
            if nextRef - (rollZeroReference + roll) < 20.toRad {
                rollZeroReference = nextRef
            }
        } else {
            nextRef = rollZeroReference - .pi / 2
            if roll < 20.toRad {
                rollZeroReference = nextRef
            }
        }
        
//        if roll > rollZeroReference && nextRef - (rollZeroReference + roll) < 20.toRad {
//            rollZeroReference = nextRef
//        } else if roll < rollZeroReference
        
//        if roll - .pi / 2 > -20.toRad {
//            rollZeroReference = rollZeroReference + .pi / 2
//        }
        
        horizonIndicatorView.rotation = motionDetector.deviceRoll
        horizonIndicatorView.zeroReference = rollZeroReference 
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

