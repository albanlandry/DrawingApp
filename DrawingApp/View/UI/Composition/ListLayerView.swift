//
//  ListLayerView.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/17.
//

import SwiftUI

struct ListLayerView: View {
    @EnvironmentObject var model: ModelData
    @Binding var document: Composition
    @Binding var documentDidUpdate: Bool
    @Binding var selected: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Layers")
                    .font(.system(size: 24))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    model.addNewLayer(name: "Layer \(model.currentDocument().DLayers.count)")
                },
                       label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(Color.white)
                })
            }.padding([.trailing, .top, .leading])
            
            Divider()
                .foregroundColor(Color.white)
                .background(Color.gray)
            
            List {
                ForEach(Array(stride(from: document.DLayers.count, to: 0, by: -1)), id: \.self) { index in
                    
                    let isSelected = (index - 1) == self.selected
                    
                    Button(action: {
                        // print(index - 1)
                        model.selectLayer(index - 1)
                    }, label: {
                        
                        LayerView(layer: $document.DLayers[index-1])
                            .background(isSelected ? Color(.sRGB, red: 0.0, green: 0.2, blue: 0.7, opacity: 1) : Color.clear)
                            .environmentObject(model)
                    })
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .background(Color.clear)
        }
        .background(Color(.sRGB, red: 0.3, green: 0.3, blue: 0.3, opacity: 0.9))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1))
        
    }
}

struct ListLayerView_Previews: PreviewProvider {
    @StateObject private static var model = ModelData()
    
    static var previews: some View {
        ListLayerView(document: $model.document, documentDidUpdate: $model.canvasUpdated, selected: $model.selected)
            .environmentObject(model)
    }
}

