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
    ///     - destHeight:
    static func fitToView(width: Double, height: Double, destWidth: Double, destHeight: Double, padding: Double = 0) -> CGRect {
        let ratio = min(destWidth/width, destHeight/height)
        let x = (destWidth - (width * ratio) ) / 2
        let y = (destHeight - (height * ratio) ) / 2
        
        let rect =  CGRect(x: x + padding,
                      y: y + padding,
                      width: (width - (padding * 2) ) * ratio,
                      height: (height - (padding * 2) )   * ratio)
        
        return rect
    }
}
