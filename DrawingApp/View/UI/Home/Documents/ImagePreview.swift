//
//  ImagePreview.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/09/09.
//

import SwiftUI
import Combine

struct ImagePreview: View {
    @Binding var data: [OnlineImage]
    @EnvironmentObject var modelData: ModelData
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(data, id: \.id) { img in
                    // Text(img.key)
                    NavigationLink(destination: CompositionDocument(shouldIUpdate: $modelData.canvasUpdated,
                                                                    m_title: img.key)
                                    .environmentObject(modelData)
                                    .navigationBarTitle(img.key)
                                    .navigationBarHidden(true)
                    ) {
                        VStack {
                            Image(uiImage: UIImage(data: img.data) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                            Text(img.key)
                        }
                    }
                }
                
                if !modelData.allImagesLoaded {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .rotationEffect(Angle(degrees: 360))
                            .animation(foreverAnimation)
                        Spacer()
                    }.onAppear {
                        print("I already appeared")
                        modelData.fetchDataFromCurrentList()
                    }
                }
            }
        }
    }
}

/*
struct ImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreview()
    }
}
*/
