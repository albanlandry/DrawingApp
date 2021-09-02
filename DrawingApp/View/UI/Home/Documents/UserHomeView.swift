//
//  UserHomeView.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/15.
//

import SwiftUI

struct UserHomeView: View {
    let spacing:CGFloat = 40
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        Text("")
    
        GeometryReader{ geo in
        
            // Get the device screen size
            let deviceScreen = UIScreen.main.bounds.size
            
            let width = deviceScreen.width > 420 ? (geo.size.width - spacing) / 3 : deviceScreen.width - spacing
            
            let cols = [
                GridItem(.adaptive(minimum: width)),
            ]
            
            NavigationView {
                VStack{
                    ScrollView{
                        LazyVGrid (columns: cols, spacing: spacing) {
                            
                            ForEach( (1...5), id: \.self ) { item in
                                
                                NavigationLink(destination: LayeredCanvas()){
                                    DocumentPreview()
                                        .frame(minHeight: width)
                                }

                            }
                            
                        }.onAppear {
                            print(UIScreen.main.bounds.size)
                        }
                    }.padding()
                }
                .navigationTitle(
                    Text("내 그림")
                        .font(.title)
                )
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)
        }
    
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeView()
    }
}
