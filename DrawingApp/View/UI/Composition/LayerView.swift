//
//  LayerRowPreview.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/17.
//

import SwiftUI

struct LayerView: View {
    @EnvironmentObject private var model: ModelData
    @Binding var layer: DrawingLayer
    
    var body: some View {
        HStack {
            
            layer.previewImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 130, maxHeight: 100)
                .edgesIgnoringSafeArea(.all)
                .border(Color.gray, width: 0.5)
                .background(Color.white)
            
            Text(layer.name)
                .font(.system(size: 16.0))
                .foregroundColor(Color(.sRGB, red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0))
            
            Spacer()
            
            Button(action: {
                model.toggleVisibility(layer: self.layer)
            }) {
                if self.layer.isVisible {
                    Image(systemName: "eye")
                        .imageScale(.medium)
                        .foregroundColor(Color.gray)
                } else {
                    Image(systemName: "eye.slash")
                        .imageScale(.medium)
                        .foregroundColor(Color.gray)
                }
            }
            
            Button(action: {
                
            },
                   label: {
                Image(systemName: "trash")
                    .imageScale(.medium)
                    .foregroundColor(Color.gray)
            }).padding()
            
        }.padding()
            .listRowBackground(Color.clear)
    }
}

struct LayerRowPreview_Previews: PreviewProvider {
    @StateObject private static var model = ModelData()
    
    static var previews: some View {
        LayerView(layer: $model.document.DLayers[0])
    }
}
