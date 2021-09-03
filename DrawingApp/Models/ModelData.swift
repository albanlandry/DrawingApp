//
//  ModelData.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/08/11.
//

import Foundation
import Combine
import KakaoSDKUser
import NaverThirdPartyLogin
import PencilKit
import SwiftUI
import AWSCore
import AWSS3

final class ModelData: NSObject, ObservableObject {
    @Environment(\.undoManager) private var undoManager
    
    @Published var isLoggedIn = false
    @Published var compositions: [Composition] = []
    @Published var currentComposition = 0 {
        didSet {
            document = currentDocument()
            selectedLayer = currentLayer()
            fireChanges()
        }
    }

    @Published var document: Composition = Composition()

    // Editing related variables
    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: 0)

    // Painting models
    @Published var layers: [DrawingLayer] = []
    @Published var toolPicker = PKToolPicker()
    // @Published var currentLayer: DrawingLayer? = nil
    @Published var selected: Int = 0 {
        didSet {
            selectedLayer = currentLayer()
            fireChanges()
            showToolPicker()
            print("selectedLayer didSet, isVisible \(selectedLayer.isVisible)")
        }
    }
    @Published var canvas: PKCanvasView = PKCanvasView()
    @Published var selectedLayer: DrawingLayer = DrawingLayer()

    // Alert messages
    @Published var showAlert: Bool = false
    @Published var message = ""

    // UI consistency
    @Published var canvasUpdated = false

    // Naver Login object
    let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override init() {
        super.init()

        compositions.append(document)

        self.selectedLayer = addNewLayer(name: "Background")
        _ = addNewLayer(name: "Layer 1")

        /*
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
         */

        initBgCanvas()
    }

    func fireChanges() {
        // showToolPicker()
        self.canvasUpdated.toggle()
        print("firechanges")
    }

    func initBgCanvas() {
        canvas = PKCanvasView()
        canvas.delegate = self
    }
}

///
/// Kakao login related extension
/// 
extension ModelData {
    // login using kakao
    func kakaoLogin() {
        // If kakao is installed, we login with kakao using the existing application
        if(UserApi.isKakaoTalkLoginAvailable()){
            loginWithKakaoApp()
        }

        loginWithKakaoAccount()
    }

    // Login with kakao using the kakao application installed on the device
    private func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                self.isLoggedIn = true
                _ = oauthToken
            }
        }
    }

    // Login with kakao using a web browser
    private func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount(prompts: [.Login]) {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                self.isLoggedIn = true
                _ = oauthToken
            }
        }
    }

    // Naver login management

    // Initialze naver login
    func initNaverSDK() {
        // Initialize naver SDK

        // Login with naver application
        naverInstance?.isNaverAppOauthEnable = true

        // Login through web browser
        naverInstance?.isInAppOauthEnable = true

        // Login in portrait mode only
        naverInstance?.isOnlyPortraitSupportedInIphone()

        // Settings to log in with naver ID
        // URL scheme entered when registering the application
        naverInstance?.serviceUrlScheme = kServiceAppUrlScheme;
        // Application client ID
        naverInstance?.consumerKey = kConsumerKey
        // Application client secret ID
        naverInstance?.consumerSecret = kConsumerSecret
        // Name of the application created on the naver platform
        naverInstance?.appName = kServiceAppName
    }

    // Launch the login process
    func naverLogin() {
        // naverInstance?.delegate = nil
        naverInstance?.delegate = self
        naverInstance?.requestThirdPartyLogin()
    }
}

///
/// Tools related extensions
///
extension ModelData {
    func pickColorAt(_ x: Int, _ y: Int) {
        canvas.getColorAt(x: x, y: y)
    }
}

///
/// Handles editing related operations
///
extension ModelData {
    // updating the currently selected canvas
    func updateCurrentLayer() {
        // self.currentLayer().canvas.drawing = self.canvas.drawing
        self.selectedLayer.canvas.drawing.append(self.canvas.drawing)
        //self.selectedLayer.canvas.drawing.append(self.canvas.drawing)
        // print("Current layer")
        // self.selectedLayer.canvas.drawing = canvas.drawing
        // canvas = PKCanvasView()
        // initBgCanvas()
        
        // self.fireChanges()
    }
    
    
    // Layers
    func addNewLayer(name: String) -> DrawingLayer {
        let layer = DrawingLayer(name)
        layer.canvas.delegate = self
        
        toolPicker.addObserver(layer.canvas)
        /*
        for l in currentDocument().DLayers {
            l.canvas.delegate = nil
        }
        */
        
        
        currentDocument().DLayers.append(layer)
        self.fireChanges()
        
        return layer
    }
    
    func currentDocument() -> Composition {
        return compositions[currentComposition]
    }
    
    func currentLayer() -> DrawingLayer {
        return compositions[currentComposition].DLayers[selected]
    }
    
    func cancelImageEditing() {
        imageData = Data(count: 0)
        // showImagePicker.toggle()
    }
    
    ///
    /// Layers management
    ///
    func addLayerAt(pos: Int, layer: DrawingLayer) {
        self.layers.insert(layer, at: pos)
    }
    
    func selectLayer(_ pos: Int) {
        selected = pos
        //print("Current layer = \(pos)")
        // showToolPicker()
        // fireChanges()
    }

    func showToolPicker() {
        /*
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        */
        
        toolPicker.setVisible(true, forFirstResponder: selectedLayer.canvas)
        selectedLayer.canvas.becomeFirstResponder()
    }

    func toggleLayerVisibility(pos: Int) {
        layers[pos].isVisible.toggle()
    }

    func toggleVisibility(layer: DrawingLayer) {
        layer.isVisible.toggle()
        self.fireChanges()
    }

    func clear() {
        canvas.drawing = PKDrawing()
    }
 
    // File functionalities
    func save () {
        // Generating image
        UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, false, 1)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: canvas.bounds.size), afterScreenUpdates: true)
        
        // Getting image
        let generatedIamge = UIGraphicsGetImageFromCurrentImageContext()
        
        // Ending render
        UIGraphicsEndImageContext()
        
        if let image = generatedIamge {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("Success")
            
            self.showAlert.toggle()
            self.message = "Saved in gallery"
        }
    }
    
    // Updating the canvas after the image is loaded from the gallery
    func updateCanvas() {
        
        // Prepare the image to be rendered on the canvas
        if let uiImg = UIImage(data: imageData){
            // Compute the width and height to modify the size of the canvas
            let width: Double = uiImg.size.width
            let height: Double = uiImg.size.height
            
            print("Width, height: ", width, height)
            
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
            let data = renderer.pngData() { ctx in
            }

            // UIGraphicsBeginImageContext(CGSize(width: width, height: height))
            do {
                let tmpCvs = try PKDrawing(data: data)

                canvas.drawing = tmpCvs

                print("Canvas updated", canvas.drawing.dataRepresentation(), data)
            }
            catch {
                print(error)
            }
        }        
    }
}

///
/// Naver authentication functionalities
///
extension ModelData: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        isLoggedIn = true
        print("Naver Login success")
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        isLoggedIn = true
        print("Refresh token")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("logout")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
}

extension ModelData: PKCanvasViewDelegate {
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        print("Finished canvasViewDidBeginUsingTool")
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        print("Finished canvasViewDidEndUsingTool")
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        print("Finished canvasViewDidFinishRendering")
    }
    
 
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        // self.updateCurrentLayer()
        self.fireChanges()
        // print("updated")
    }
}

///
/// Functions related to AWS3 operations
///
extension ModelData {    
    func upload(key: String?) {
        let data: Data = Data() // Data to be uploaded
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async (execute: {
                print("Task in progress: ", Float(progress.fractionCompleted))
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = {(task, error) -> Void in
            DispatchQueue.main.async {
                print("Task Completed")
            }
        }
        
        // Upload task
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data,
                                   bucket: "wedit-autocolor",
                                   key: "complete",
                                   contentType: "img/jpg",
                                   expression: expression,
                                   completionHandler: completionHandler)
            .continueWith {
                (task) -> AnyObject? in
            
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
            
                if let _ = task.result {
                    print("Do something with upload task")
                }
            
                return nil
            }
    }

    ///
    /// Download a file from AWSS$ bucket
    ///
    func downloadData(key: String = "test_2.jpg") {
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            // Do something e.g. Update a progress bar.
            print("Download in progress: ", Float(progress.fractionCompleted))
        })
        }

        /*
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed downloads, `error` contains the error object.
                print("The transfer is completed")
            })
        }
        */

        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(
            fromBucket: "wedit-autocolor",
            key: "original/\(key)",
            expression: expression // ,
             // completionHandler: completionHandler
        ) { (task, url, data, error) in
            if error != nil {
                print(error!)
                return
            }
           
            if data != nil{
                // self.imageData = data!
                DispatchQueue.main.async {
                    self.selectedLayer.imageData = data
                    self.fireChanges()
                    print("Task Completed", data!)
                }
            }
        }
            /*
            .continueWith {
                (task) -> AnyObject? in if let error = task.error {
                   print("Error: \(error.localizedDescription)")
                }

                if let _ = task.result {
                  // Do something with downloadTask.
                    print("Do something with downloadTask. Here is the task.")
                    print("result", task.result?.status, task.result?.request)
                    print("Data: ", task.result)
                }
                return nil;
            }
             */
    }
}

///
/// Custom credentials for amazon aws3 buckets
///
class MyCredentialsProvider: NSObject, AWSCredentialsProvider {
    func credentials() -> AWSTask<AWSCredentials> {
        let credentials = AWSCredentials(accessKey: "AKIAQZDEST2OFX3V52XE", secretKey: "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", sessionKey: nil, expiration: nil)
        
        return AWSTask(result: credentials)
    }
    
    func invalidateCachedTemporaryCredentials() {
        
    }
}
