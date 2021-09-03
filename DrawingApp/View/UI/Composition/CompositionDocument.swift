//
//  CompositionDocument.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/17.
//

import SwiftUI

struct CompositionDocument: View {
    // States
    @State private var showLayerList = false
    @State private var lastScale: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var offset = CGSize()
    @State private var translation: CGSize = .zero
    @EnvironmentObject var model: ModelData
    @Binding var shouldIUpdate: Bool
    
    // Animation transition
    
    /*
    let layerBtn = AnyView(Button(action: {
        self.showLayerList.toggle()
    } ) {
        Image(systemName: "square.stack.3d.up.fill")
            .font(.system(size: 26))
            .accessibilityLabel("Clear")
    })
    */
    
    var body: some View {
        GeometryReader { frame in
            let maxWidth =  frame.size.width
            let maxHeight = frame.size.height
            let paddingtop = 60.0
            let paddingRight = 10.0
            let toolbarPadding = 20.0
            let toolbarBtnPadding = 30.0
            
            ZStack {
                // VStack {
                //    Spacer()
                    
                    // Divider()

                ZStack {
                    LayeredCanvas()
                        .gesture(MagnificationGesture()
                                    .onChanged { val in
                            _ = val / self.lastScale
                            self.lastScale = val
                            self.scale = val * self.scale
                            
                        }.onEnded{ val in
                            self.lastScale = 1.0
                        }
                                 /*
                                    .simultaneously(with: DragGesture()
                                            .onChanged { val in
                            self.translation = val.translation
                            
                            if self.scale > 1.0 {
                                self.offset.width += self.translation.width
                                self.offset.height += self.translation.height
                                self.translation = .zero
                            }
                            
                        }.onEnded{ val in
                            self.translation = .zero
                            
                        })
                                 */
                        )
                        // .background(Color.gray)
                        .scaleEffect(scale)
                        .offset(self.offset)
                    .environmentObject(model)
                }
                .offset(x: 0, y: paddingtop)
            
                HStack {
                    
                    Spacer()
                    /*
                    Button(action: {
                        // self.showLayerList.toggle()
                        // model.pickColorAt(10, 10)
                    } ) {
                        Image(systemName: "pencil")
                            .font(.system(size: 26))
                            .accessibilityLabel("Pencil")
                    }
                    */
                    
                    Button(action: {
                        // self.showLayerList.toggle()
                    } ) {
                        Image(systemName: "paintbrush.pointed.fill")
                            .font(.system(size: 26))
                            .accessibilityLabel("Brush")
                    }.padding(.leading, toolbarBtnPadding)
                    
                    Button(action: {
                        self.showLayerList.toggle()
                    } ) {
                        Image(systemName: "square.fill.on.square.fill")
                            .font(.system(size: 26))
                            .accessibilityLabel("Clear")
                    }.padding(.leading, toolbarBtnPadding)
                    
                }
                .padding()
                .frame(width: maxWidth, height: paddingtop, alignment: .trailing)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .offset(x: 0, y: -maxHeight/2 + 30)
                
                
                // .frame(maxWidth: .infinity, maxHeight: paddingtop, alignment: .trailing)
                // .frame(width: .zero, height: paddingtop, alignment: .trailing)
                
                // }
                
                if showLayerList {
                    GeometryReader { listSize in
                        let listWidth = maxWidth * 2 / 6
                        let offsetX = maxWidth - (listWidth + paddingRight)
                        
                        ListLayerView(document: $model.document, documentDidUpdate: $model.canvasUpdated, selected: $model.selected)
                            // .background(Color.blue)
                            .environmentObject(model)
                            .transition(.offset())
                            .offset(x: offsetX, y: paddingtop)
                            //.scaledToFit()
                        .frame(maxWidth: listWidth, maxHeight: maxHeight * 3 / 5)
                
                    }
                }
            }
        }

    }

}

/*
struct CompositionDocument_Previews: PreviewProvider {
    static var previews: some View {
        CompositionDocument()
            .environmentObject(ModelData())
    }
}
*/
