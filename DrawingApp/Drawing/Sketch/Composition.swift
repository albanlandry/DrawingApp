//
//  Layer.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/17.
//

import Foundation
import UIKit
import SwiftUI

class Layer: Identifiable {
    var id = UUID()
    var name: String = ""
    var position: CGPoint = CGPoint()
    var opacity: Float = 0.0
    var isLocked: Bool = false
    var isVisible: Bool = true
    var isTransparent: Bool = false
    var buffer: UIImage?
    var color: Color = Color.white
    var bgColor: UIColor = UIColor.white
    var canvas: SketchView
    var size: CGSize
    
    init(name:String, _ width: Int, _ height: Int) {
        self.name = name
        size = CGSize(width: width, height: height)
        canvas = SketchView()
    }
    
    init(width: Int, height: Int) {
        size = CGSize(width: width, height: height)
        canvas = SketchView()
    }
    
    init(_ name:String) {
        self.name = name
        size = CGSize(width: CGFloat.zero, height: CGFloat.zero)
        canvas = SketchView()
    }
}


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
    var layers: [Layer] = [Layer]()
    var DLayers: [DrawingLayer] = [DrawingLayer]()
    var currentLayer: Int = 0
    var size: CGSize
    
    init() {
        size = .zero
    }
    
    init(width: Int, height: Int) {
        size = CGSize(width: width, height: height)
        self.addLayer(Layer(name: "layer \(layers.count)", width, height))
    }
    
    private func addLayer(_ layer: Layer) {
        layers.append(layer)
    }
    
    func addLayerAfter(pos: Int) {
        
    }
    
    func addLayerBefore(pos: Int) {
        
    }
    
    func removeLayerAt(pos: Int){
        
    }
    
    func showLayer(pos: Int) {
        
    }
    
    func hideLayer(pos: Int) {
        
    }
    
    // Image renderer
    func render() {
        
    }
}
