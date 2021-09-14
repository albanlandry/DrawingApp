//
//  LayeredCanvas.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/08.
//

import SwiftUI
import Alamofire
import PencilKit

struct LayeredCanvas: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
            ZStack {
                /*
                ForEach($model.document.DLayers) { layer in
                    if layer.wrappedValue.isVisible {
                        PaintingCanvas(imageData: $model.imageData, toolPicker: $model.toolPicker, canvas: layer.canvas)
                    }
                }
                
                PaintingCanvas(imageData: $model.imageData, toolPicker: $model.toolPicker, isToolPickerVisible: true, canvas: $model.canvas)
                */
                ForEach($model.document.DLayers) { layer in
                    if layer.wrappedValue.isVisible {
                        if layer.wrappedValue.id != model.selectedLayer.id {
                            // PaintingCanvas(imageData: layer.imageData, toolPicker: $model.toolPicker, canvas: layer.canvas)
                            DrawableImage(imageData: layer.imageData, canvas: layer.canvas)
                        }
                    }
                }
        
                ForEach($model.document.DLayers) { layer in
                    if layer.wrappedValue.isVisible {
                        if layer.wrappedValue.id == model.selectedLayer.id {
                            // PaintingCanvas(imageData: layer.imageData, toolPicker: $model.toolPicker, canvas: layer.canvas)
                            DrawableImage(imageData: layer.imageData, canvas: layer.canvas)
                        }
                    }
                }
            }
            .overlay(
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(Color.blue)
            )
    }
}

struct LayeredCanvas_Previews: PreviewProvider {
    @StateObject private static var model = ModelData()
    
    static var previews: some View {
        LayeredCanvas()
            .environmentObject(model)
    }
}
