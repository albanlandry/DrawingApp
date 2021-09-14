//
//  DrawingCanvas.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/08.
//

import UIKit
import SwiftUI


/// Drawing Context
///
import PencilKit

class PathBasedCanvas: UIView {
    
    var brush = BBrush()
    var currentPoint: CGPoint?
    var drawingLayer: CAShapeLayer?
    var lineColor = UIColor(patternImage: UIImage(named: "PencilTexture")!)
    var line = [CGPoint]() {
        didSet {  }
    }
    
    var linePath = UIBezierPath()
    
    var strokes =  [PKStroke]()
    var strokePoints = [PKStrokePoint]()
    
    var sublayers: [CALayer] {
        return self.layer.sublayers ?? [CALayer]()
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        
        let drawingLayer = self.drawingLayer ?? CAShapeLayer()
        let linePath = UIBezierPath()
        drawingLayer.contentsScale = Display.scale
    

        for (index, point) in line.enumerated() {
            if(index  == 0) {
                linePath.move(to: point)
            } else {
                let mid = DrawingHelper.midPoints(p1: line[index-1], p2: point)
                let bias = 0.3
                let control = CGPoint(x: line[index-1].x + bias, y: line[index-1].y + bias)
            
                linePath.addQuadCurve(to: mid, controlPoint: control)
                // linePath.addQuadCurve(to: mid, control: line[index-1])
                // linePath.addCurve(to: mid, controlPoint1: point, controlPoint2: line[index-1])
            }
        }
        
        /*
        let A = CGPoint(x: 1.0, y: 1.0)
        let B = CGPoint(x: 2.0, y: 3.0)
        let C = CGPoint(x: 4.0, y: 3.0)
        let D = CGPoint(x: 6.0, y: 4.0)
        
        print(CubicCurvePoint(A, B, C, D, u: 0.0))
        print(CubicCurvePoint(A, B, C, D, u: 0.2))
        print(CubicCurvePoint(A, B, C, D, u: 0.4))
        print(CubicCurvePoint(A, B, C, D, u: 0.6))
        print(CubicCurvePoint(A, B, C, D, u: 0.8))
        print(CubicCurvePoint(A, B, C, D, u: 1.0))
        print()
        print(quadCurvePoint(A, B, C, u: 0.0))
        print(quadCurvePoint(A, B, C, u: 0.2))
        print(quadCurvePoint(A, B, C, u: 0.4))
        print(quadCurvePoint(A, B, C, u: 0.6))
        print(quadCurvePoint(A, B, C, u: 0.8))
        print(quadCurvePoint(A, B, C, u: 1.0))
        print()
        */
        
        
        // brush.drawOnlayer(layer: drawingLayer, line: line)
        // lineColor.setStroke()
        drawingLayer.path = linePath.cgPath
        drawingLayer.opacity = 0.9
        drawingLayer.lineCap = .round
        drawingLayer.lineJoin = .round
        drawingLayer.miterLimit = 0
        drawingLayer.lineWidth = 5
        drawingLayer.fillColor = UIColor.clear.cgColor
        drawingLayer.strokeColor = lineColor.cgColor
        
        if self.drawingLayer == nil {
            self.drawingLayer = drawingLayer
            layer.addSublayer(drawingLayer)
        }

        
    }
    
    func checkIfTooManyPoints() {
        let maxPoints = 25
        if line.count > maxPoints {
            updateFlattenedLayer()
            // we leave two points to ensure no gaps or sharp angles
            line.removeFirst(maxPoints - 2)
        }
    }
    
    func flattenImage() {
        updateFlattenedLayer()
        line.removeAll()
    }
    
    func updateFlattenedLayer() {
        // 1
        guard let drawingLayer = drawingLayer,
            // 2
            let optionalDrawing = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
                NSKeyedArchiver.archivedData(withRootObject: drawingLayer, requiringSecureCoding: false))
                as? CAShapeLayer?,
            // 3
            let newDrawing = optionalDrawing else { return }
        // 4
        layer.addSublayer(newDrawing)
    }
    
    func clear() {
        emptyFlattenedLayers()
        drawingLayer?.removeFromSuperlayer()
        drawingLayer = nil
        line.removeAll()
        layer.setNeedsDisplay()
    }
    
    func emptyFlattenedLayers() {
        for case let layer as CAShapeLayer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
    
}

extension PathBasedCanvas {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: self) else { return }
        line.append(newTouchPoint)
        strokePoints.append(
            PKStrokePoint(
                location: newTouchPoint,
                timeOffset: 0.2,
                size: CGSize(width: 5, height: 5),
                opacity: 1.0,
                force: 1.0,
                azimuth: 0.0,
                altitude: 1)
        )
        
        let lastTouchPoint: CGPoint = line.last ?? .zero
        
        let rect = DrawingHelper.calculateRectBetween(lastPoint: lastTouchPoint, newPoint: newTouchPoint, lineWidth: 5)
        
        layer.setNeedsDisplay(rect)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        flattenImage()
    }
    
}


// Struct directly dealing with the canvas view to draw element
/*
struct CCanvas: UIViewRepresentable {
    
    var pathedCanvas = PathBasedCanvas()
    var bitmapCanvas = BitmapCanvas()
    var sketchView = SketchView()
    
    func makeUIView(context: Context) -> some UIView {
        pathedCanvas.backgroundColor = .clear
        bitmapCanvas.backgroundColor = .clear
        
        return sketchView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
*/

struct DrawingBitmapCanvas: UIViewRepresentable {
    func makeUIView(context: Context) -> some BitmapCanvas {
        let canvas = BitmapCanvas()
        canvas.backgroundColor = .clear
        
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
