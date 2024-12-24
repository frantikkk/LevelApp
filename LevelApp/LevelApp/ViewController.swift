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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizonIndicatorView = HorizonIndicatorView(frame: CGRect(origin: .zero, size: .init(width: view.bounds.width, height: view.bounds.width)))
        view.addSubview(horizonIndicatorView)
        
        horizonIndicatorView.center = view.center
        
        horizonIndicatorView.backgroundColor = .green //.black
        
        startMotionMonitoring()
    }

    @IBAction func fixTapped(_ sender: Any) {
        motionDetector.fixInclinationReference()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        motionDetector.resetInclincationReference()
    }
    
}

private extension ViewController {
    func startMotionMonitoring() {
        motionDetector = MotionDetector(updateInterval: 0.01)
        motionDetector.onUpdate = { [weak self] in
            guard let self else { return }
            horizonIndicatorView.rotation = motionDetector.deviceRoll
            horizonIndicatorView.rotationReference = motionDetector.rollInclinationReference
        }
        
        motionDetector.start()
    }
}

