//
//  UtilExtensions.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/09/09.
//

import Foundation

class RangedArray<T> {
    var current: Int = 0
    var limit: Int =  10
    var data: [T]
    
    final var hasReachedEnd:Bool {
        self.end == data.count
    }
    
    final var isEmpty:Bool {
        self.data.count <= 0
    }
    
    private var start: Int = 0
    private var end: Int = 0
    
    init(data: [T]) {
        self.data = data
    }
    
    func next() -> RangedArray<T> {
        self.next(limit)
    }
    
    func next(_ count: Int) -> RangedArray<T> {
        let temp = self.current
        current += count
        
        return self.next(from: temp, to: current)
    }
    
    private func next(from: Int, to: Int) -> RangedArray<T> {
        let _min = min(from, to)
        let _max = min(max(from, to), self.data.count)
        start = _min
        end = _max
        
        return self
    }
    
    func prev() -> RangedArray<T> {
        return prev(limit)
    }
    
    func prev(_ count: Int) -> RangedArray<T> {
        current -= start
        
        return self.next(from: max(0, current - count), to: max(0, current))
    }

    func result( res: ([T]) -> Void) {
        res(Array(data[start..<end]))
    }
}
