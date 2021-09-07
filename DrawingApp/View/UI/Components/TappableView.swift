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

///
///
///
struct PannablePinchView: UIViewRepresentable
{
    var callbacks: (UIPanGestureRecognizer?, UIPinchGestureRecognizer?, UITapGestureRecognizer?)  -> Void
    var fingersCount: Int = 2

    typealias UIViewType = UIView

    func makeCoordinator() -> PannablePinchView.Coordinator
    {
        Coordinator(tapCallback: self.callbacks)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        // PannablePinchView(panGesture: <#T##(UIPanGestureRecognizer?) -> Void#>, pinchGesture: <#T##(UIPinchGestureRecognizer?) -> Void#>, tapCallback: <#T##(UITapGestureRecognizer?) -> Void#>)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:)))
        /// Set number of touches.
        doubleTapGestureRecognizer.numberOfTouchesRequired = self.fingersCount
        doubleTapGestureRecognizer.delegate = context.coordinator
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(sender:)))
        panGestureRecognizer.delegate = context.coordinator
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(sender:)))
        pinchGestureRecognizer.delegate = context.coordinator

       
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        view.addGestureRecognizer(panGestureRecognizer)
        view.addGestureRecognizer(pinchGestureRecognizer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate
    {
        var callbacks: (UIPanGestureRecognizer?, UIPinchGestureRecognizer?, UITapGestureRecognizer?)  -> Void

        init(tapCallback: @escaping (UIPanGestureRecognizer?, UIPinchGestureRecognizer?, UITapGestureRecognizer?)  -> Void) {
            self.callbacks = tapCallback
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            
            if let gesture = gestureRecognizer as? UITapGestureRecognizer {
                if gesture.numberOfTapsRequired < 2 {
                    return false
                }
            }
            
            if gestureRecognizer is UITapGestureRecognizer
                && ((gestureRecognizer as? UITapGestureRecognizer)?.numberOfTapsRequired)! < 2
                && otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }

            if gestureRecognizer is UITapGestureRecognizer
                && ((gestureRecognizer as? UITapGestureRecognizer)?.numberOfTapsRequired)! < 2
                && otherGestureRecognizer is UIPinchGestureRecognizer {
                return true
            }
            
            return false
        }
        /*
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            
            return false
        }
        */
        
        @objc func handlePan(sender: UIPanGestureRecognizer)
        {
            self.callbacks(sender, nil, nil)
        }
        
        @objc func handlePinch(sender: UIPinchGestureRecognizer)
        {
            self.callbacks(nil, sender, nil)
        }
        
        @objc func handleTap(sender: UITapGestureRecognizer)
        {
            self.callbacks(nil, nil, sender)
        }
    }
}

///
///
///
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


///
/// DraggableView
///
struct DraggableView: ViewModifier {
    @State var m_offset = CGPoint()
    
    func body(content: Content) -> some View {
        content.gesture(DragGesture(minimumDistance: 0)
            .onChanged { value in
                
            })
            .offset(x: m_offset.x, y: m_offset.y)
    }
}

extension View {
    func draggable () -> some View {
        return modifier(DraggableView())
    }
}
