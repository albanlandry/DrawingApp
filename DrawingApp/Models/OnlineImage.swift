//
//  OnlineImage.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/09/10.
//

import Foundation

struct OnlineImage: Decodable, Identifiable {
    var id = UUID()
    var key: String
    var data: Data
    
    init(key: String, data: Data){
        self.key = key
        self.data = data
    }
    
    init(key: String) {
        self.init(key: key, data: Data(count: 0))
    }
    
}
