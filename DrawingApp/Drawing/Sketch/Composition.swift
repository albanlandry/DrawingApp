//
//  Layer.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/17.
//

import Foundation
import UIKit
import SwiftUI

///
/// Layer preview
///
struct LayerPreview: UIViewRepresentable {
    // var layer: Layer
    @Binding var layer: DrawingLayer
    
    private var imageView = UIImageView()
    
    func makeUIView(context: Context) -> some UIImageView {
        let drawing = self.layer.canvas.drawing
        let bounds = drawing.bounds
        
        // Retrieve the data image
        let img = drawing.image(from: bounds, scale: 1.0)
        
        return UIImageView(image: img)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

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
