//
//  PopupButton.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/18.
//

import SwiftUI

struct PopupButton: View {
    var body: some View {
        VStack(alignment: .leading){
            Button(action: {
                
            }, label: {
                Text("Test")
            })
            
            ListLayerView()
        }.padding()
    }
}

struct PopupButton_Previews: PreviewProvider {
    static var previews: some View {
        PopupButton()
    }
}
