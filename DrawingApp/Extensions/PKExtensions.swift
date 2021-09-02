//
//  PKExtensions.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/19.
//

import Foundation
import PencilKit
import UIKit

extension PKCanvasView {
    func getColorAt(x: Int, y: Int) {
        let data = self.drawing.dataRepresentation()
        let width = Int(self.bounds.width)
        let height = Int(self.bounds.height)
        let img = self.drawing.image(from: self.bounds, scale: 1.0)

        guard let pngData = img.pngData() else {return }
        
        print("Range ", data.subdata(in: Range(1...3))[1])
        /*
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bitsPercomponent = 8
        let bytesPerRow = bytesPerPixel * width
        
        */
        
        print(data, data.count, data.startIndex, data.endIndex)
        print(pngData, width * height)
    }
}
