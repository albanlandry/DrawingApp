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
