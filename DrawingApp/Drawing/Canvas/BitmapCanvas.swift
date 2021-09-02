//
//  CanvasDrawing.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/14.
//

import UIKit
import SwiftUI
import PencilKit

///
/// BitmapCanvas
///
class BitmapCanvas: UIImageView{
    var spiralPoints = [CGPoint]()
    var lastTouchPosition: CGPoint?
    var beforeLastTouchPosition: CGPoint?
    var displayLink: CADisplayLink?
    var brush = BBrush()
    
    // this is where we store the drawn shape
    var drawingLayer: CALayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
    }
    
    func setupDrawingLayerIfNeeded() {
        guard drawingLayer == nil else { return }
        let sublayer = CALayer()
        sublayer.contentsScale = Display.scale
        layer.addSublayer(sublayer)
        drawingLayer = sublayer
    }
    
    func stamp(p: CGPoint) {
        setupDrawingLayerIfNeeded()
        
        // let img = brush.image?.cgImage
        
        let line = CAShapeLayer()
        line.contentsScale = Display.scale
        line.frame = CGRect(x: p.x,
                            y: p.y,
                            width: (brush.image?.size.width)!,
                            height: (brush.image?.size.height)!)
        // line.bounds = CGRect(x: p.x, y: p.x, width: brush.mRadius * 2, height: brush.mRadius * 2)
        line.contents = brush.image?.cgImage
        
        drawingLayer?.addSublayer(line)
        
        if let count = drawingLayer?.sublayers?.count, count > 200 {
            flattenToImage()
        }
    }
    
    func stamp(from a: CGPoint, to b: CGPoint) {
        let distance = DrawingHelper.distance(from: a, to: b)
        let angle = DrawingHelper.angleBetween(a: a, b: b)
        
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
        
        
        
        var i = 0.0
        while i < distance {
            
            stamp(p: CGPoint(
                x: a.x + (sin(angle) * i) - brush.mRadius/2,
                y: a.y + (cos(angle) * i) - brush.mRadius/2
            ))
            
            i += 1.0
        }
        
        // ADDED CODE
        _ = DrawingHelper.midPoints(p1: a, p2: b)
        // ADDED CODE END
        
    }
    
    func stampQuadCurve(from: CGPoint, to: CGPoint, control: CGPoint) {
        
        _ = 3.0
        
        for u in stride(from: 0.0, to: 1.0, by: 0.01) {
            let pt = quadCurvePoint2(from, control, to, u: Float(u));
            // print(pt)
            
            stamp(p: pt)
            // stamp(p: quadCurvePoint(from, control, to, u: u))
        }
        
    }
    
    func drawBezier(from start: CGPoint, to end: CGPoint) {
        setupDrawingLayerIfNeeded()
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        
        line.contentsScale = Display.scale
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = UIColor.red.cgColor
        line.opacity = 1
        line.lineWidth = 10
        line.lineCap = .round
        line.strokeColor = UIColor.red.cgColor
        
        drawingLayer?.addSublayer(line)
        
        if let count = drawingLayer?.sublayers?.count, count > 100 {
            flattenToImage()
        }
    }
    
    func flattenToImage() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, Display.scale)
        if let context = UIGraphicsGetCurrentContext() {
            
            // keep old drawings
            if let image = self.image {
                image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            }
            
            // add new drawings
            drawingLayer?.render(in: context)
            
            let output = UIGraphicsGetImageFromCurrentImageContext()
            self.image = output
        }
        clearSublayers()
        UIGraphicsEndImageContext()
    }
    
    func clearSublayers() {
        drawingLayer?.removeFromSuperlayer()
        drawingLayer = nil
    }
    
    func clear() {
        // stopAutoDrawing()
        clearSublayers()
        spiralPoints.removeAll()
        image = nil
    }
}


/** Events handlers */
extension BitmapCanvas {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: self) else { return }
        lastTouchPosition = newTouchPoint
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: self) else { return }
        guard let previousTouchPoint = lastTouchPosition else { return }
        
        if beforeLastTouchPosition != nil {
            let mid = DrawingHelper.midPoints(p1: previousTouchPoint, p2: newTouchPoint)
            _ = DrawingHelper.distance(from: previousTouchPoint, to: newTouchPoint)
            _ = DrawingHelper.distance(from: beforeLastTouchPosition!, to: mid)
            print(DrawingHelper.distance(from: beforeLastTouchPosition!, to: mid))
            
            // if(distance < 5) {
                stampQuadCurve(from: beforeLastTouchPosition!, to: mid, control: previousTouchPoint)
            //}
            
            //  print("distance", DrawingHelper.distance(from: beforeLastTouchPosition!, to: lastTouchPosition!))
            
        }
        
        // stamp(from: previousTouchPoint, to: newTouchPoint)
        beforeLastTouchPosition = lastTouchPosition
        lastTouchPosition = newTouchPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        beforeLastTouchPosition = nil
        flattenToImage()
        lastTouchPosition = nil
    }
    
    
}

///
/// Brushes
///
class BBrush {
    
    var mRadius = 1.0
    //var shape = ""
    var color = CGColor(red: 0.95, green: 0.68, blue: 1.0, alpha: 1)
    var softness = 0.2
    var hard = false
    var image: UIImage?
    
    init () {
        image = createShapeImge()
    }
    
    func makeShape() -> CAShapeLayer {
        let shape = CAShapeLayer()
        let path = UIBezierPath()
        shape.bounds = CGRect(x: 0, y: 0, width: mRadius * 2, height: mRadius * 2)
        
        let innerRadius = Int(ceil(softness * (0.5 - mRadius) + mRadius))
        let outerRadius = Int(ceil(mRadius))
        var i = outerRadius
        
        // print("inner", innerRadius, "out", outerRadius)
        
        // The alpha level is always proportional to the difference between innner, opaque
        // radius and outer, transparent radius
        let alphaStep = 1.0 / Float((outerRadius - innerRadius + 1))
        shape.opacity = alphaStep
        
        // Set the alpha context here....
        while(i >= innerRadius){
            let layer = CAShapeLayer()
            let center = CGPoint(x:  mRadius, y: mRadius)
            let scale = (2.0 * Float(i)) / (2.0 * Float(outerRadius) )
            
            path.addArc(withCenter: center, radius: CGFloat(i) * CGFloat(scale), startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
            layer.lineWidth = 4
            layer.path = path.cgPath
            layer.strokeColor = self.color
            layer.strokeStart = 2
            layer.strokeEnd = 2
            // shape.strokePath()
            shape.addSublayer(layer)
            
            i = i - 1;
        }
        
        return shape
    }
    
    private func createShapeImge() -> UIImage? {
        // Create a new Graphic context
        UIGraphicsBeginImageContext(CGSize(width: mRadius * 2, height: mRadius * 2))
        
        if let ctx = UIGraphicsGetCurrentContext() {
            // ctx.addEllipse(in: CGRect(x: 0, y: 0, width: ctx.width, height: ctx.height))
            
            let innerRadius = Int(ceil(softness * (0.5 - mRadius) + mRadius))
            let outerRadius = Int(ceil(mRadius))
            var i = outerRadius
            
            // The alpha level is always proportional to the difference between innner, opaque
            // radius and outer, transparent radius
            let alphaStep = 1.0 / Float((outerRadius - innerRadius + 1))
            
            // Set the alpha context here....
            ctx.setAlpha(CGFloat(alphaStep))
            ctx.setStrokeColor(color)
        
            // ctx.addArc(center: CGPoint(x: mRadius, y: mRadius), radius: mRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            // ctx.strokePath()
            
            
            while(i >= innerRadius){
                let center = CGPoint(x:  mRadius, y: mRadius)
                let scale = (2.0 * Float(i)) / (2.0 * Float(outerRadius) )

                ctx.addArc(center: center, radius: CGFloat(i) * CGFloat(scale), startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
                
                ctx.setFillColor(color)
                ctx.setLineWidth(1)
                ctx.fillPath()
                // ctx.strokePath()
                
                i = i - 1;
            }
            
            return (UIGraphicsGetImageFromCurrentImageContext())
            
        }
        
        UIGraphicsEndImageContext()
        
        return nil
    }
    
}


// Pattern test
class PatternView: UIView {
    // The code to draw a pattern
    // it draws a circular path in the graphic context
    let drawPattern: CGPatternDrawPatternCallback = { _, context in
        context.addArc(center: CGPoint(x: 20, y: 20), radius: 10.0, startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: false)
        context.setFillColor(UIColor.black.cgColor)
        context.fillPath()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        UIColor.orange.setFill()
        context.fill(rect)
        
        guard let patternSpace = CGColorSpace(patternBaseSpace: nil) else {return}
        context.setFillColorSpace(patternSpace)
        
        // Creates the structure that holds the callbacks to draw a pattern
        var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawPattern, releaseInfo: nil)
        
        // Create the patterns used to stroke or fill the path
        guard let pattern = CGPattern(info: nil,
                                      bounds: CGRect(x: 0, y: 0, width: 20, height: 20),
                                      matrix: .identity,
                                      xStep: 20,
                                      yStep: 10,
                                      tiling: .constantSpacing,
                                      isColored: true,
                                      callbacks: &callbacks)
        else {return}
        
        var alpha: CGFloat = 1.0
        context.setFillPattern(pattern, colorComponents: &alpha)
        context.fill(rect)
        
    }
    
}
