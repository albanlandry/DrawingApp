//
//  Layer.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/17.
//

import Foundation
import UIKit
import SwiftUI

class Composition: Identifiable {
    var id = UUID()
    var DLayers: [DrawingLayer] = [DrawingLayer]()
    var currentLayer: Int = 0
    var size: CGSize
    
    init() {
        size = .zero
    }
    
    init(width: Int, height: Int) {
        size = CGSize(width: width, height: height)
    }
}
