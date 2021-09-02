//
//  PaintingCanvas.swift
//  Painter
//
//  Created by 케이넷이엔지 on 2021/07/02.
//

import SwiftUI
import PencilKit

struct PaintingCanvas: UIViewRepresentable {

    // @State var imageData: Data = Data(count: 0)
    @Binding var imageData: Data?
    @Binding var toolPicker: PKToolPicker
    @State var isToolPickerVisible: Bool = false
    // private let drawingHandler = CanvasDrawingDelegateHandler()
    
    // To capture drawing for saving into albums
    @Binding var canvas: PKCanvasView
    
    func makeUIView(context: Context) -> some PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = UIColor.clear
        // canvas.maximumZoomScale = 5.0
        // canvas.minimumZoomScale = 0.25
        print("canvasView")
        initBgImage()
        // if isToolPickerVisible {
        // showToolPicker()
        // }
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // print("UPDATING UI>>>...", imageData, canvas)
        
        // print("Strokes", canvas.drawing.strokes.count)
        // canvas.drawing = PKDrawing()
        
        initBgImage()
        /*
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            // Prepare the canvas to receive the image
            canvas.backgroundColor = .clear
            canvas.isOpaque = false
            // canvas.drawing.bounds.width = imageView.bounds.width
            // canvas.drawing.bounds.size.height = imageView.bounds.height
            
            // Set the image to the back of the canvas
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
        }
        */
    }
}

private extension PaintingCanvas {
    func initBgImage() {
        if self.imageData != nil {
            let imageView = UIImageView(image: UIImage(data: self.imageData!))
            // canvas.drawing.bounds.width = imageView.bounds.width
            // canvas.drawing.bounds.size.height = imageView.bounds.height
            
            self.canvas.subviews[0].addSubview(imageView)
        }
    }
    
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvas)
        
        toolPicker.addObserver(canvas)
        
        canvas.becomeFirstResponder()
    }
}


struct CanvasDrawing: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isDrawing: Bool
    
    let ink = PKInkingTool(.pencil, color: .black)
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> some PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDrawing ? ink : eraser
        
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.tool = isDrawing ? ink : eraser
    }
}


struct CPaintingCanvas: UIViewRepresentable {
    // private let toolPicker = PKToolPicker()
    // private let drawingHandler = CanvasDrawingDelegateHandler()
    private var canvas: PKCanvasView = CustomCanvas()
    
    func makeUIView(context: Context) -> some PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.maximumZoomScale = 5.0
        canvas.minimumZoomScale = 0.25
        
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

class CustomCanvas: PKCanvasView {
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        print("Draw layer")
    }
    
    override func draw(_ rect: CGRect) {
        print("Draw")
    }
    
}


/*
struct PaintingCanvas_Previews: PreviewProvider {
 
    static var previews: some View {
        PaintingCanvas(canvas: PKCanvasView())
            .navigationTitle("Drawing")
            .navigationBarTitleDisplayMode(.inline)
    }
}
*/
