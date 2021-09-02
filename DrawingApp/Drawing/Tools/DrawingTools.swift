//
//  DrawingTools.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/14.
//

import Foundation
import UIKit


// Publishers and subscribers

protocol EventObserver {
    var id: UUID {get set}
}

protocol EventPublisher {
    var observers: [EventObserver] {get set}
    
    func addObserver(observer: EventObserver)
    
    func removeObserver(observer: EventObserver)
    
    func removeAll()
}



// Brushes

protocol BrushObserver: EventObserver, Identifiable {
    func onDrawingPoint(point: CGPoint, pattern: CGLayer)
}

protocol BrushTool: EventPublisher {
    var spacing: CGFloat { get set }
    var size: CGFloat { get set }
    var clr: CGColor { get set }
    var opacity: CGFloat { get set }
    var shape: CGLayer? {get set}
    
    func drawPoint(p: CGPoint)
    func drawLine(start: CGPoint, end: CGPoint)
    
}

extension BrushTool {
    
    // func 
    
}

class SoftBrushTool: BrushTool {
    var size: CGFloat = 15.0
    
    var clr: CGColor = UIColor.black.cgColor
    
    var opacity: CGFloat = 0.0
    
    var shape: CGLayer?
    
    var spacing: CGFloat = 0.25
    
    var observers: [EventObserver] = []
    
    var path: UIBezierPath?
    
    init() {
        path = makeShape()
        makeLayer()
    }
    
    func addObserver(observer: EventObserver) {
        observers.append(observer)
    }
    
    func removeObserver(observer: EventObserver) {
        observers = observers.filter { obs in
            return obs.id != observer.id
        }
    }
    
    func removeAll() {
        observers.removeAll()
    }
    
    func drawPoint(p: CGPoint) {
        // Create a new Graphic context
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        
        if let ctx = UIGraphicsGetCurrentContext() {
            let bounds = CGRect(x: 0, y: 0, width: size, height: size);
            
            let layer = CGLayer.init(ctx, size: bounds.size, auxiliaryInfo: nil)
            
            guard let layerCtx = layer?.context else {return}
            
            layerCtx.addPath( (path?.cgPath)! )
            layerCtx.setStrokeColor(UIColor.red.cgColor)
            // layerCtx.setFillColor(UIColor.yellow.cgColor)
            // layerCtx.fillPath()
            layerCtx.setLineWidth(5)
            layerCtx.strokePath()
            
            observers.forEach { obs in
                (obs as! BrushObserver).onDrawingPoint(point: p, pattern: layer!)
            }
        }
        
        UIGraphicsEndImageContext() // End the graphric context
    }
    
    func drawLine(start: CGPoint, end: CGPoint) {

        let spacing = size * self.spacing
        let points = DrawingHelper.computeNextPoint(start: start, end: end, spacing: spacing)
        
        // print("Ponits", points)
        // Draws the first point of the line
        drawPoint(p: start)
    
        // Draw the rest of the points
        
        points.forEach { p in
            drawPoint(p: p)
        }
    }
    
    //
    private func makeShape() -> UIBezierPath {
        // let bounds = CGRect(x: 0, y: 0, width: 5, height: 5);
        let center = CGPoint(x: size / 2, y: size / 2)
        
        let path = UIBezierPath()
        
        path.addArc(withCenter: center, radius: size / 2, startAngle: 0, endAngle: CGFloat(deg2rad(270)), clockwise: true)
        
        
        return path
    }
    
    private func makeLayer() {
    
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        
        if let ctx = UIGraphicsGetCurrentContext() {
            let bounds = CGRect(x: 0, y: 0, width: size, height: size);
            
            shape = CGLayer.init(ctx, size: bounds.size, auxiliaryInfo: nil)
            
            guard let layerCtx = shape?.context else {return}
            
            layerCtx.addPath( (path?.cgPath)! )
            layerCtx.setStrokeColor(UIColor.red.cgColor)
            // layerCtx.setFillColor(UIColor.yellow.cgColor)
            layerCtx.setLineWidth(5)
            // layerCtx.fillPath()
            layerCtx.strokePath()
        }
        
        UIGraphicsEndImageContext() // End the graphric context
        
    }
    
}
