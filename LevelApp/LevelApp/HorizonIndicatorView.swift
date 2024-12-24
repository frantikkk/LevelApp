//
//  HorizonIndicatorView.swift
//  LevelApp
//
//  Created by Yury Shalin on 23.12.2024.
//

import UIKit

class HorizonIndicatorView: UIView {
    
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
    
    override func draw(_ rect: CGRect) {
//        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.clear(rect)
//            
//            let lineLength: CGFloat = 150  // Длина линии
//            let lineWidth: CGFloat = 2.0   // Ширина линии
//
//            // Переместить начало координат в центр представления
//            context.translateBy(x: bounds.midX, y: bounds.midY)
//            
////            // Повернуть контекст на заданный угол в радианах
////            context.rotate(by: rotationAngle * .pi / 180)
//            
//            // Установить цвет линии
//            context.setStrokeColor(UIColor.red.cgColor)
//            context.setLineWidth(lineWidth)
//            
//            // Нарисовать линию, начиная с центра
//            context.move(to: CGPoint(x: -lineLength / 2, y: 0))  // Начало линии слева от центра
//            context.addLine(to: CGPoint(x: lineLength / 2, y: 0))  // Конец линии справа от центра
//            
//            // Применить рисование
//            context.strokePath()
//        
//        // Повернуть контекст на заданный угол в радианах
//        context.rotate(by: rotationAngle * .pi / 180)
//        
//        // Нарисовать линию, начиная с центра
//        context.setStrokeColor(UIColor.blue.cgColor)
//        
//        context.move(to: CGPoint(x: -lineLength / 2, y: 0))  // Начало линии слева от центра
//        context.addLine(to: CGPoint(x: lineLength / 2, y: 0))  // Конец линии справа от центра
//        
//        // Применить рисование
//        context.strokePath()
        
        drawIndicator(at: context)
    }
}

extension HorizonIndicatorView {
    func drawIndicator(at context: CGContext, inclinationReferenceAngle: Double = 0) {
        
        let markLength = 80.0
        let staticMarkHeight = 2.0
        let dynamticMarkHeight = 4.0
        let markCenterOffset = 80.0
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // Origin of coorindates in the center of view
        context.translateBy(x: bounds.midX, y: bounds.midY)
        
        // Draw static marks
        
        context.rotate(by: rotationReference)
        
        context.setLineWidth(staticMarkHeight)
        context.setStrokeColor(UIColor.white.cgColor)
        
        context.move(to: CGPoint(x: -(markCenterOffset + markLength), y: 0))
        context.addLine(to: CGPoint(x: -markCenterOffset, y: 0))
        
        context.move(to: CGPoint(x: markCenterOffset + markLength, y: 0))
        context.addLine(to: CGPoint(x: markCenterOffset, y: 0))
        
        context.drawPath(using: .fillStroke)
        
        context.rotate(by: -rotationReference)
        
        // Draw dynamic marks
        
        context.rotate(by: rotation)
        
        context.setLineWidth(dynamticMarkHeight)
        context.setStrokeColor(UIColor.red.cgColor)
        
        context.move(to: CGPoint(x: -(markCenterOffset + markLength), y: 0))
        context.addLine(to: CGPoint(x: -markCenterOffset, y: 0))
        
        context.drawPath(using: .fillStroke)
        
        context.setStrokeColor(UIColor.white.cgColor)
        
        context.move(to: CGPoint(x: markCenterOffset + markLength, y: 0))
        context.addLine(to: CGPoint(x: markCenterOffset, y: 0))
        
        context.drawPath(using: .fillStroke)
        
//        UIGraphicsPushContext(context)
        
        // Draw degrees value
        
        context.setStrokeColor(UIColor.white.cgColor)
        
        let relativeRotation = rotationReference - rotation
//        let angleText = "\(Int(-relativeRotation * 180 / .pi)) °"
        let angleText = "\(Int(-rotation * 180 / .pi)) °"
        
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
    }
}

//extension Double {
//    func describeAsFixedLengthString(integerDigits: Int = 2, fractionDigits: Int = 0) -> String {
//        self.formatted(
//            .number
//                .sign(strategy: .always())
//                .precision(
//                    .integerAndFractionLength(integer: integerDigits, fraction: fractionDigits)
//                )
//        )
//    }
//}

