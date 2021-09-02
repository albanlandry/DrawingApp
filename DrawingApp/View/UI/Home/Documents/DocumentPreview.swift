//
//  DocumentPreview.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/15.
//

import SwiftUI

struct DocumentPreview: View {
    private let padding = 5
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                    Button (action: {
                        
                    },
                            label:{
                        
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Image("logo_digidog")
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }

                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "trash.fill").foregroundColor(Color.black)
                            .font(.headline)
                    }).body
                    .offset(x: geo.size.width / 2 - 30, y: geo.size.height / 2 - 30)
                    

            }
        }
    }
}

struct DocumentPreview_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPreview()
    }
}
