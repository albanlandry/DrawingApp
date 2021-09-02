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
    
    init()
    {
        print("LayeredCanvasView")
    }

    var body: some View {
        // GeometryReader { frame in
            
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
                            PaintingCanvas(imageData: $model.imageData, toolPicker: $model.toolPicker, canvas: layer.canvas)
                        }
                    }
                }
                
                
                ForEach($model.document.DLayers) { layer in
                    if layer.wrappedValue.isVisible {
                        if layer.wrappedValue.id == model.selectedLayer.id {
                            PaintingCanvas(imageData: $model.imageData, toolPicker: $model.toolPicker, canvas: layer.canvas)
                        }
                    }
                }
                
                /*
                if $model.selectedLayer.wrappedValue.isVisible {
                    PaintingCanvas(imageData: $model.imageData, toolPicker: $model.toolPicker, canvas: $model.selectedLayer.canvas)
                }
                 */
                

                /*
                ForEach (0..<model.currentDocument().DLayers.count) { index in
                    PaintingCanvas(imageData: $model.imageData, canvas: $model.compositions[model.currentComposition].DLayers[index].canvas)
                }
                 */
                /*
                ForEach (0..<model.currentDocument().DLayers.count) { index in
                    PaintingCanvas(imageData: $model.imageData, canvas: $model.compositions[model.currentComposition].DLayers[index].canvas)
                }
                 */
                /*
                Checkboard(rows: Int(maxWidth) / cellSize,
                           columns: Int(maxHeight) / cellSize)
                    .fill(Color.gray)
                    .frame(width: maxWidth, height: maxHeight)
                */
                // CCanvas()
                // PaintingCanvas(imageData: $model.imageData, canvas: $model.canvas)
            }
            .border(Color.black, width: 1)
            // .shadow(color: .black, radius: 3)
       //  }// .background(Color.blue)
    }
}

struct LayeredCanvas_Previews: PreviewProvider {
    @StateObject private static var model = ModelData()
    
    static var previews: some View {
        LayeredCanvas()
            .environmentObject(model)
    }
}
