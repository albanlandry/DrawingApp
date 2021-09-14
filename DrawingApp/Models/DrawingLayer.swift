//
//  DrawingLayer.swift
//  Painter
//
//  Created by 케이넷이엔지 on 2021/07/05.
//
import Foundation
import PencilKit
import UIKit
import SwiftUI

class DrawingLayer: Identifiable {
    var id = UUID()
    var name: String = ""
    var size = (w: 0.0, h: 0.0)
    var opacity = 0.0
    var pos = (x: 0.0, y: 0.0)
    var isVisible:Bool = true
    var canvas: PKCanvasView
    var bgColor: Color = Color.white
    var bounds: CGRect?
    var preview: UIImage?
    var imageData: Data?
    
    init() {
        canvas = PKCanvasView()
        size = (w: Double (canvas.bounds.width), h: Double(canvas.bounds.height))
        // print(size)
    }
    
    convenience init(_ name: String) {
        self.init()
        self.name = name
    }
    
    convenience init(name: String, color: Color) {
        self.init(name)
        
        self.setBgColor(color: color)
    }
    
    func setBgColor(color: Color) {
        let rect = CGRect(x: 0, y: 0, width: size.w, height: size.h)
        canvas.backgroundColor = UIColor(color)
        canvas.draw(rect)
    }
    
    func setSize(w: Double, h: Double) {
        self.size.w = w
        self.size.h = h
    }
    
    func previewImage() -> Image {
        /*
        let drawing = canvas.drawing
        let bounds = drawing.bounds

        // Retrieve the data image
        let img = drawing.image(from: bounds, scale: 1.0)
        preview = UIImage(cgImage: img.cgImage!)
        */
        
        return Image(uiImage: self.flatten()!)
    }
    
    func flatten() -> UIImage? {
        // let drawing = canvas.drawing
        // let bounds = drawing.bounds

        UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, false, 1)
        
        // guard let context = UIGraphicsGetCurrentContext() else {return UIImage()}
        
        UIImage(data: imageData!)?.draw(in: canvas.bounds)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: canvas.bounds.size), afterScreenUpdates: false)
        
        // Getting image
        let generatedIamge = UIGraphicsGetImageFromCurrentImageContext()

        // Ending render
        UIGraphicsEndImageContext()
        
        
        // Retrieve the data image
        // let img = drawing.image(from: bounds, scale: 1.0)
        // preview = UIImage(cgImage: img.cgImage!)
        
        return generatedIamge
    }
    
}

struct DrawingLayerPreview: UIViewRepresentable {
    var layer: DrawingLayer
    
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
