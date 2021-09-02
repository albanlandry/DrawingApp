//
//  PopupViewController.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/17.
//

import UIKit
import SwiftUI

class PopupViewController: UIViewController {
    let frame: CGRect
    let content: AnyView
    // var popup: UIHostingController?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPopup()
    }
    
    func createPopup() {
        print("createPopup")
        let hostingViewController = UIHostingController(rootView: content)
        hostingViewController.modalPresentationStyle = .popover
        hostingViewController.popoverPresentationController?.delegate = self
        hostingViewController.popoverPresentationController?.sourceView = self.view
        hostingViewController.popoverPresentationController?.sourceRect = frame
        hostingViewController.view.backgroundColor = nil
        
        // need to manually set preferredContentSize for the popover
        // but thankfully we can use sizeThatFits(:) to force SwiftUI view to size itself
        let popoverMaxSize = CGSize(width: 250, height: 500)
        hostingViewController.preferredContentSize = hostingViewController.sizeThatFits(in: popoverMaxSize)
        
        self.present(hostingViewController, animated: true, completion: nil)
        // popup = hostingViewController
        
    }
    
    init(frame: CGRect, content: AnyView){
        self.frame = frame
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
}

extension PopupViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // this is what forces popovers on iphone
    }
}

struct PopupRepresentation: UIViewControllerRepresentable {
    var frame: CGRect
    var view: AnyView
    
    func makeUIViewController(context: Context) -> some PopupViewController {
        print("makeUI poprepresentation")
        let vc = PopupViewController(frame: frame, content: view)
        // vc.present(vc, animated: true, completion: nil)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // typealias UIViewControllerType = UIViewController
    }
}
