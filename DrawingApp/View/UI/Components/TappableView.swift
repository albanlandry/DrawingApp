//
//  TappableView.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/31.
//

import Foundation

import SwiftUI

struct TappableView: UIViewRepresentable
{
    var tapCallback: (UITapGestureRecognizer) -> Void
    var fingersCount: Int = 2

    typealias UIViewType = UIView

    func makeCoordinator() -> TappableView.Coordinator
    {
        Coordinator(tapCallback: self.tapCallback)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:)))
       
        /// Set number of touches.
        doubleTapGestureRecognizer.numberOfTouchesRequired = self.fingersCount
       
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }

    class Coordinator
    {
        var tapCallback: (UITapGestureRecognizer) -> Void

        init(tapCallback: @escaping (UITapGestureRecognizer) -> Void)
        {
            self.tapCallback = tapCallback
        }

        @objc func handleTap(sender: UITapGestureRecognizer)
        {
            self.tapCallback(sender)
        }
    }
}

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isActive: Bool {
        switch self {
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive, .pressing:
            return false
        case .dragging:
            return true
        }
    }
}
