//
//  HorizonIndicatorView.swift
//  LevelApp
//
//  Created by Yury Shalin on 23.12.2024.
//

import UIKit

class HorizonIndicatorView: UIView {
    
    let markLength = 80.0
    let staticMarkHeight = 1.0
    let dynamticMarkHeight = 4.0
    let markCenterOffset = 80.0
    
    var zeroReferenceLocked: Bool = false
    
    var rotation: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var zeroReference: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    var orientationZeroReference: Double = 0.0 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
    
    var indicatorRotation: Double {
        -rotation
    }
    
    var indicatorZeroReference: Double {
        -zeroReference
//        orientationZeroReference != 0 ? -orientationZeroReference : -zeroReference
    }
    
    var relativeRotation: Double {
        let relativeRotation = rotation - zeroReference
        if zeroReferenceLocked {
            // For example, rotation is 15 deg, zero reference is 30 degress.
            // We are in scope of 0-359 deg, so 15 deg minus 30 deg should return 345, but not -15.
            return relativeRotation < 0 ? relativeRotation + 2 * .pi : relativeRotation
        } else {
            return relativeRotation > 90.toRad ? relativeRotation - 360.toRad : relativeRotation
        }
    }
    
    var displayingRotationAngle: Int {
        zeroReferenceLocked ? angleDisplayValueLocked : angleDisplayValueNonLocked
    }
    
    var angleDisplayValueNonLocked: Int {
        return Int(relativeRotation.toDeg)
    }
    
    var angleDisplayValueLocked: Int {
        if relativeRotation < 180.toRad {
            return Int(relativeRotation.toDeg)
        } else {
            return Int((relativeRotation - 360.toRad).toDeg)
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.clear(rect)
        
        drawIndicator(at: context)
    }
}

private extension HorizonIndicatorView {
    
    func drawIndicator(at context: CGContext, inclinationReferenceAngle: Double = 0) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // Origin of coorindates in the center of view
        context.translateBy(x: bounds.midX, y: bounds.midY)
        
        drawStaticMarks(in: context)
        drawDynamicMarks(in: context)
        drawDegreesValue(in: context)
        drawArcs(in: context)
        
    }
    
    func drawStaticMarks(in context: CGContext) {
        context.rotate(by: indicatorZeroReference)
        
        context.setLineWidth(staticMarkHeight)
        context.setStrokeColor(UIColor.lightGray.cgColor)
        
        context.move(to: CGPoint(x: -(markCenterOffset + markLength), y: 0))
        context.addLine(to: CGPoint(x: -markCenterOffset, y: 0))
        
        context.move(to: CGPoint(x: markCenterOffset + markLength, y: 0))
        context.addLine(to: CGPoint(x: markCenterOffset, y: 0))
        
        context.drawPath(using: .fillStroke)
        
        context.rotate(by: -indicatorZeroReference)
    }
    
    func drawDynamicMarks(in context: CGContext) {
        context.rotate(by: indicatorRotation)
        
        context.setLineWidth(dynamticMarkHeight)
        context.setStrokeColor(UIColor.red.cgColor)
        
        context.move(to: CGPoint(x: -(markCenterOffset + markLength), y: 0))
        context.addLine(to: CGPoint(x: -markCenterOffset, y: 0))
        
        context.drawPath(using: .fillStroke)
        
        context.setStrokeColor(UIColor.white.cgColor)
        
        context.move(to: CGPoint(x: markCenterOffset + markLength, y: 0))
        context.addLine(to: CGPoint(x: markCenterOffset, y: 0))
        
        context.drawPath(using: .fillStroke)
        
        context.rotate(by: -indicatorRotation)
    }
    
    func drawDegreesValue(in context: CGContext) {
        context.rotate(by: indicatorRotation)
        
        context.setStrokeColor(UIColor.white.cgColor)
        
        let angleText = "\(displayingRotationAngle) °"
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 56, weight: .medium),
            .foregroundColor: UIColor.white
        ]
        
        let attributedString = NSAttributedString(string: angleText, attributes: attributes)
        let textSize = attributedString.size()
        let textRect = CGRect(
                    x: -textSize.width / 2,
                    y: -textSize.height / 2,
                    width: textSize.width,
                    height: textSize.height
                )
        
        attributedString.draw(in: textRect)
        
        context.rotate(by: -indicatorRotation)
    }
    
    func drawArcs(in context: CGContext) {
        guard indicatorZeroReference != 0, zeroReferenceLocked else { return }
        
        context.setLineWidth(markLength)
        context.setAlpha(0.5)
        
        // Right arc
        context.beginPath()
        
        let startAngle = CGFloat(indicatorRotation)
        let endAngle = CGFloat(indicatorZeroReference)
        
        var clockWise = false
        if relativeRotation > .pi {
            clockWise = !clockWise
        }
        context.addArc(center: .zero, radius: markCenterOffset + markLength / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockWise)
        
        context.strokePath()
        
        // Left arc
        context.beginPath()
        
        let startAngle2: CGFloat = CGFloat(indicatorRotation) + .pi
        let endAngle2: CGFloat = indicatorZeroReference + .pi
        
        var clockWise2 = false
        if relativeRotation > .pi {
            clockWise2 = !clockWise2
        }
        context.addArc(center: .zero, radius: markCenterOffset + markLength / 2, startAngle: startAngle2, endAngle: endAngle2, clockwise: clockWise2)
        context.strokePath()
        
        context.setAlpha(1.0)
    }
}

