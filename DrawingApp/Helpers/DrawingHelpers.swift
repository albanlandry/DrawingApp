//
//  DrawingHelpers.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/09.
//

import Foundation
import UIKit
import SwiftUI

struct DrawingHelper {
    
    // Finds the mid point between p1 and p2
    static func midPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2 , y: (p1.y + p2.y) / 2)
    }
    
    // Compute the next point based on the spacing value
    static func computeNextPoint(start: CGPoint, end: CGPoint, spacing: CGFloat) -> [CGPoint] {
        
        // Find the direction in which we need to interpolate, position of negative
        var points: [CGPoint] = []
        let pXY = CGPoint(x: end.x - start.x, y: end.y - start.y)
        let dirXY = sqrt( pow(pXY.x, 2) + pow(pXY.y, 2) )

        print("spacing", spacing, "Distance", dirXY)
       
        if dirXY >= spacing {
            print("draw")
            // We iterate a nunmber of steps computed previously from the starting point
            var steps = Int( dirXY / spacing) // To find the number of iteration until we reach the end points
            // print("(dirXY: \(dirXY), spacing: \(spacing),  steps: \(steps)")
            
            if (steps > 0) {
                
                let deltaX: Double = (Double(end.x) - Double(start.x)) / Double(steps)
                
                // with x = x0 + deltaX
                var x = start.x + deltaX // We start at the next point
                
                while(steps > 0) {
                    // y = [y0(x1 - x) + y1(x - x0)] / (x1 - x0)
                    let y = (start.y * (end.x - x) + end.y * (x - start.x)) / (end.x - start.x)
                    points.append(CGPoint(x: x, y: y))
                    
                    x += deltaX
                    
                    steps -= 1
                }
             
                // print("start, ", start, "End", end, "pXY", pXY, "(Distance: \(dirXY), steps \(steps), deltaX: \(deltaX) ), count \(points.count)", points)
            }
        }
        
        return points
    }
    
    // Compares whether the given point is inside the range
    
    static func redrawBounds(points: [CGPoint]) -> CGRect? {
        if points.isEmpty {return nil}
        
        let xs = points.map {$0.x} as [CGFloat]
        let ys = points.map {$0.y} as [CGFloat]
        
        return CGRect(x: xs.min()!, y: ys.min()!, width: xs.max()!, height: ys.max()!)
    }
    
    static func calculateRectBetween(lastPoint: CGPoint, newPoint: CGPoint, lineWidth: CGFloat) -> CGRect {
        let originX = min(lastPoint.x, newPoint.x) - (lineWidth / 2)
        let originY = min(lastPoint.y, newPoint.y) - (lineWidth / 2)

        let maxX = max(lastPoint.x, newPoint.x) + (lineWidth / 2)
        let maxY = max(lastPoint.y, newPoint.y) + (lineWidth / 2)

        let width = maxX - originX
        let height = maxY - originY

        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    static func distance(from a: CGPoint, to b: CGPoint) -> CGFloat {
        return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
    }
    
    static func angleBetween(a: CGPoint, b: CGPoint) -> Double {
        return atan2(b.x - a.x, b.y - a.y)
    }
    
}

func factorial (_ n: Double) -> Float {
    return (n == 0) ? Float(1.0) : Float(n) * factorial(n - 1)
}

func quadCurveBFactorial(index: Int, u: Float) -> Float {
    let fact = factorial(2) / (factorial(Double(index)) * factorial(2 - Double(index)) )
    let tmp = pow(u, Float(index)) * pow(1.0 - u, 2.0 - Float(index))
    
    return fact * tmp
}

func quadCurvePoint(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, u: Float) -> CGPoint {
    
    let x =   (Float(p0.x) * quadCurveBFactorial(index: 0, u: u))
    + (Float(p1.x) * quadCurveBFactorial(index: 1, u: u))
    + (Float(p2.x) * quadCurveBFactorial(index: 2, u: u))
    
    let y = (Float(p0.y) * quadCurveBFactorial(index: 0, u: u))
    + (Float(p1.y) * quadCurveBFactorial(index: 1, u: u))
    + (Float(p2.y) * quadCurveBFactorial(index: 2, u: u))
    
    let du = CGPoint(x: CGFloat(x),
                     y: CGFloat(y))
    
    return du
}

func quadCurvePoint2(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, u: Float) -> CGPoint {
    let x = (1.0 - u) * (1.0 - u) * Float(p0.x)
            + 2 * u * (1.0 - u) * Float(p1.x)
            + u * u * Float(p2.x)
    let y = (1.0 - u) * (1.0 - u) * Float(p0.y)
            + 2 * u * (1.0 - u) * Float(p1.y)
            + u * u * Float(p2.y)
    
    let du = CGPoint(x: CGFloat(x),
                     y: CGFloat(y))
    
    return du
}

func quadCurveLenth(from: CGPoint, to: CGPoint, control: CGPoint) -> Double {
    let kSubdivisions = 50
    let step:Double = 1.0 / Double(kSubdivisions)
    var length:Double = 0.0
    var prevPoint = from
    
    for i in 1...kSubdivisions {
        let t = Double(i) * step;
        
        let x = ((1.0 - t) * (1.0 - t) * from.x) + (2.0 * (1.0 - t) * t * control.x) + (t * t * to.x)
        let y = ((1.0 - t) * (1.0 - t) * from.y) + (2.0 * (1.0 - t) * t * control.y) + (t * t * to.y)
        
        let diff = CGPoint(x: x - prevPoint.x, y: y - prevPoint.y)
        
        length += sqrt(diff.x * diff.x + diff.y * diff.y)
        
        prevPoint = CGPoint(x: x, y: y)
    
    }
    
    return length
}

// Cubic bezier
func CubicCurveBFactorial(index: Int, u: Double) -> Double {
    let fact = factorial(3) / (factorial(Double(index)) * factorial(3 - Double(index)) )
    let tmp = pow(u, Double(index)) * pow(1.0 - u, 3.0 - Double(index))
    
    return Double(fact) * tmp
}


func CubicCurvePoint(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint, u: Double) -> CGPoint {
    
    let du = CGPoint(x: (p0.x * CubicCurveBFactorial(index: 0, u: u))
                         + (p1.x * CubicCurveBFactorial(index: 1, u: u))
                         + (p2.x * CubicCurveBFactorial(index: 2, u: u))
                         + (p3.x * CubicCurveBFactorial(index: 3, u: u)) ,
                     y: (p0.y * CubicCurveBFactorial(index: 0, u: u))
                        + (p1.y * CubicCurveBFactorial(index: 1, u: u))
                        + (p2.y * CubicCurveBFactorial(index: 2, u: u))
                        + (p3.y * CubicCurveBFactorial(index: 3, u: u))
    )
    
    return du
}

