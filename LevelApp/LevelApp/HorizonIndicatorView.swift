//
//  HorizonIndicatorView.swift
//  LevelApp
//
//  Created by Yury Shalin on 23.12.2024.
//

import UIKit

class HorizonIndicatorView: UIView {
    
    let markLength = 80.0
    let staticMarkHeight = 2.0
    let dynamticMarkHeight = 4.0
    let markCenterOffset = 80.0
    
    var rotation: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()  // Перерисовать представление при изменении угла
        }
    }
    
    var rotationReference: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var indicatorRotation: CGFloat {
        -rotation
    }
    
    var indicatorRotationReference: CGFloat {
        -rotationReference
    }
    
    var displayingRotationAngle: Int {
        
//        return Int(rotation * 180 / .pi)
        
        guard rotationReference == 0 else {
            var relativeRotation = rotation - rotationReference
            if relativeRotation < 0 {
                relativeRotation = relativeRotation + 2 * .pi
            }
            return Int(relativeRotation * 180 / .pi)
        }
        
        let rotationInDeg = Int(rotation * 180 / .pi)
        switch rotationInDeg {
        case 0...89:
            return Int(rotation * 180 / .pi)
        case 90...179:
            return Int((rotation - .pi / 2) * 180 / .pi)
        case 180...269:
            return Int((rotation - .pi) * 180 / .pi)
        case 270...359:
            return Int((rotation - .pi - .pi / 2) * 180 / .pi)
        default: return Int(rotation * 180 / .pi)
        }
    }
    
    override func draw(_ rect: CGRect) {
//        super.draw(rect)
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
        context.rotate(by: indicatorRotationReference)
        
        context.setLineWidth(staticMarkHeight)
        context.setStrokeColor(UIColor.white.cgColor)
        
        context.move(to: CGPoint(x: -(markCenterOffset + markLength), y: 0))
        context.addLine(to: CGPoint(x: -markCenterOffset, y: 0))
        
        context.move(to: CGPoint(x: markCenterOffset + markLength, y: 0))
        context.addLine(to: CGPoint(x: markCenterOffset, y: 0))
        
        context.drawPath(using: .fillStroke)
        
        context.rotate(by: -indicatorRotationReference)
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
        guard indicatorRotationReference != 0 else { return }
        
        context.setLineWidth(markLength)
        context.setAlpha(0.5)
        
        // Right arc
        context.beginPath()
        
        var relativeRotation = rotation - rotationReference
        if relativeRotation < 0 {
            relativeRotation = relativeRotation + 2 * .pi
        }
        
        let startAngle = CGFloat(indicatorRotation)
        let endAngle = CGFloat(indicatorRotationReference)
        
        var clockWise = false
        if relativeRotation > .pi {
            clockWise = !clockWise
        }
        context.addArc(center: .zero, radius: markCenterOffset + markLength / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockWise)
        
        context.strokePath()
        
        // Left arc
        context.beginPath()
        
        let startAngle2: CGFloat = CGFloat(indicatorRotation) + .pi
        let endAngle2: CGFloat = indicatorRotationReference + .pi
        
        var clockWise2 = false
        if relativeRotation > .pi {
            clockWise2 = !clockWise2
        }
        context.addArc(center: .zero, radius: markCenterOffset + markLength / 2, startAngle: startAngle2, endAngle: endAngle2, clockwise: clockWise2)
        context.strokePath()
        
        context.setAlpha(1.0)
    }
}

