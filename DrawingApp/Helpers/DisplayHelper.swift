//
//  DisplayHelper.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/13.
//

import UIKit

public final class Display {
    static var scale:CGFloat {return UIScreen.main.scale}
    
    
    /// Returns a frame containing the position and dimension
    /// for the given dimension to fit into the view dimensions, and be centered
    ///
    /// - Parameters
    ///     - width:
    ///     - height:
    ///     - destWidth:
///         - destHeight:
    static func fitToView(width: Double, height: Double, destWidth: Double, destHeight: Double, padding: Double = 0) -> CGRect {
        let destRatio = min(destWidth/width, destHeight/height)
        let srcRatio = min(width/destWidth, height/destHeight)
        let ratio = destRatio
        
        let rect =  CGRect(x: (destWidth - width * ratio) / 2 + padding,
                      y: (destHeight - height * ratio) / 2 + padding,
                      width: (width - padding * 2) * ratio,
                      height: (height - padding * 2) * ratio)
        
        return rect
    }
}
