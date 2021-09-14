//
//  DrawableImage.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/09/07.
//

import SwiftUI
import PencilKit

struct DrawableImage: View {
    @EnvironmentObject var model: ModelData
    @Binding var imageData: Data?
    @Binding var canvas: PKCanvasView
    
    var body: some View {
        ZStack {
            if imageData != nil {
                Image(uiImage: UIImage(data: imageData ?? Data(count: .zero)) ?? UIImage())
                    .resizable()
                    .scaledToFit()
            }
            
            PaintingCanvas(imageData: $imageData, toolPicker: $model.toolPicker, canvas: $canvas)
        }
    }
}

/*
struct DrawableImage_Previews: PreviewProvider {
    static var previews: some View {
        DrawableImage()
    }
}
*/
