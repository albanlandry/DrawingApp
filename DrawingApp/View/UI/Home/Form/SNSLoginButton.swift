//
//  SNSLoginButton.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/14.
//

import SwiftUI

struct SNSLoginButton: View {
    
    var image: Image
    var text: String
    var action:  () -> Void
    
    var body: some View {
        Button(action: self.action,
               label:
        {
            HStack {
                self.image
                    .scaledToFit()
                    // .frame(width: 40, height: 40, alignment: .center)
                
                Spacer()
                Text(text)
                    .foregroundColor(Color.black)
                Spacer()
            }
        })                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            //.clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}

struct SNSLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        SNSLoginButton(image: Image("icon_naver"), text: "login", action: {})
    }
}
