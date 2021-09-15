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
    @State private var shouldDrag = false
    @State private var canDrag = false
    @State private var showSaveDialog = false
    @State private var showDiscardDialog = false
    @State private var showLogoutDialog = false
    @State private var goBack = false
    
    @State var dimensions: CGSize = CGSize(width: 900, height: 600)
    
    @EnvironmentObject var model: ModelData
    @Binding var shouldIUpdate: Bool
    
    var m_title = ""
    
    var body: some View {
        GeometryReader { frame in
            let paddingtop = 60.0
            let paddingRight = 10.0
            let toolbarBtnPadding = 30.0
            let maxWidth =  frame.size.width
            let maxHeight = frame.size.height
            let docWidth = dimensions.width > 0 ? dimensions.width : maxWidth
            let docHeight = dimensions.height > 0 ? dimensions.height : maxHeight
            let docFrame = Display.fitToView(width: docWidth, height: docHeight, destWidth: maxWidth, destHeight: maxHeight - paddingtop)
            
            if model.showDocument {
                ZStack(alignment: .topLeading) {
                    ZStack {
                        LayeredCanvas()
                            .gesture(MagnificationGesture()
                                        .onChanged { val in
                                _ = val / self.lastScale

                                adjustScale(val: val)
                                
                            }.onEnded{ val in
                                self.lastScale = 1.0
                            }
                                        .simultaneously(with: shouldDrag ? DragGesture()
                                                .onChanged { val in
                                self.translation = val.translation
                                
                                if self.scale > 1.0 {
                                    self.offset.width += self.translation.width
                                    self.offset.height += self.translation.height
                                    self.translation = .zero
                                }
                                
                            }.onEnded{ val in
                                self.translation = .zero
                                
                            } : nil)
                            )
                            .frame(width: docFrame.size.width, height: docFrame.size.height, alignment: .leading)
                            .scaleEffect(scale)
                            .offset(x: docFrame.origin.x + self.offset.width, y: docFrame.origin.y + self.offset.height + paddingRight)
                        .environmentObject(model)
                    }
                    .onReceive(model.$imageData) { value in
                        let image = UIImage(data: value)
                        
                        withAnimation {
                            dimensions = image?.size ?? dimensions
                        }
        
                    }
                    .offset(x: 0, y: paddingtop)
                    
                    /// Toolbar
                    HStack {
                        
                        NavigationLink(destination: ContentView()
                                        .environmentObject(model), isActive: !$model.isLoggedIn){
                            EmptyView()
                        }
                        
                        Button (action: {
                            showLogoutDialog = true
                        }) {
                            HStack {
                                Image(systemName: "power")
                                    .font(.system(size: 26))
                                    .accessibilityLabel("logout")
                                Text("logout")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.white)
                            }
                        }.alert(isPresented: $showLogoutDialog){
                            Alert(
                                title: Text("로그아웃겠습니까?"),
                                message: Text(""),
                                primaryButton: .default (Text("확인")) {
                                model.logout()
                            },
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showDiscardDialog = true
                        } ) {
                            Image(systemName: "pip.remove")
                                .font(.system(size: 26))
                                .accessibilityLabel("corrupted")
                        }.padding(.leading, toolbarBtnPadding)
                            .alert(isPresented: $showDiscardDialog){
                                Alert(
                                    title: Text("이미지를 버리겠습니까?"),
                                    message: Text(""),
                                    primaryButton: .default (Text("확인")) {
                                    model.corruptedDocument()
                                },
                                    secondaryButton: .cancel(Text("취소"))
                                    
                                )
                            }
                        
                        Button(action: {
                            self.showSaveDialog = true
                        } ) {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 26))
                                .accessibilityLabel("Save")
                        }.padding(.leading, toolbarBtnPadding)
                            .alert(isPresented: $showSaveDialog){
                                Alert(
                                    title: Text("저장하시겠습니까?"),
                                    message: Text(""),
                                    primaryButton: .default (Text("확인")) {
                                    model.saveCurrentDocument()
                                },
                                    secondaryButton: .cancel(Text("취소"))
                                    
                                )
                            }
                      
                        if canDrag == true {
                            Button(action: {
                                shouldDrag.toggle()
                            } ) {
                                Image(systemName: shouldDrag ? "hand.raised.fill" : "hand.raised.slash")
                                    .font(.system(size: 26))
                                    .accessibilityLabel("Drag")
                                    .padding([.leading], toolbarBtnPadding)
                            }
                        }
                        
                        Button(action: {
                            model.showToolPicker()
                            shouldDrag = false
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
                    .padding(20)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    
                    if showLayerList {
                        let listWidth = maxWidth * 2 / 6
                        let offsetX = maxWidth - (listWidth + paddingRight)
                        
                        ListLayerView(document: $model.document, documentDidUpdate: $model.canvasUpdated, selected: $model.selected)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 0.5))
                        .environmentObject(model)
                        .transition(.offset())
                        .frame(maxWidth: listWidth, maxHeight: maxHeight * 3 / 5)
                        .offset(x: offsetX, y: paddingtop + paddingRight + 10)
                    }
                }
                // .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .foregroundColor(Color.white)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    print("It appeared", self.m_title)
                    model.setCurrentImage(title: self.m_title)
                }
            }
        }
    }
    
    ///
    /// Adjust the scale of the image
    ///
    func adjustScale(val: CGFloat) {
        self.lastScale = val
        self.scale = val * self.scale
        
        if self.scale >= 8.0 {
            self.scale = 8.0
        }
        
        if self.scale < 0.25 {
            self.scale = 0.25
        }
        
        if self.scale > 1.0 {
            canDrag = true
        }else {
            canDrag = false
            shouldDrag = false
            
            withAnimation {
                self.offset.width = 0
                self.offset.height = 0
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
