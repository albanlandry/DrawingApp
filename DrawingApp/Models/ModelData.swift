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

class ModelData: NSObject, ObservableObject {
    @Published var isLoggedIn = false
    @Published var document: Composition = Composition()
    @Published var compositions: [Composition] = []
    @Published var showDocument: Bool = true
    @Published var allImagesLoaded: Bool = true // batch related value

    // Editing related variables
    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: .zero)
    @Published var currentImageIndex = 0
    
    // User data
    private var username: String = ""
    private var password: String = ""
    
    private var currentUserOriginalFolderKey:String  {
        get{
            return "original/\(username.lowercased())/"
        }
    }
    
    private var currentUserCompleteFolderKey:String  {
        get {
            return "complete/\(username.lowercased())/"
        }
    }
    
    private var currentUserCorruptedFolderKey:String  {
        get {
            return "corrupted/\(username.lowercased())/"
        }
    }
    
    private var currentComposition = 0 {
        didSet {
            document = currentDocument
            // selectedLayer = currentLayer()
            fireChanges()
        }
    }
    
    private var currentDocument:Composition {
        return compositions[currentComposition]
    }
    
    private var listKeys = RangedArray<String?>(data: [])

    
    ///
    /// Store the indexes of the images already in used in documents
    ///
    private var imagesInDocuments: [Int] = [] // Holds the indices of the images with existing documents
    
    func addImagesInDocumentIndex(_ index: Int) {
        self.imagesInDocuments.append(index)
    }
    
    func removeImagesInDocumentIndex(_ index: Int) {
        let pos = imagesInDocuments.firstIndex(of: index)
        
        if pos != nil {
            self.imagesInDocuments.remove(at: pos!)
            self.removeDocument(pos!)
        }
    }
    
    ///
    func setCurrentImage (title: String) {
        currentImageIndex = imageRepos.firstIndex {
            $0.key == title
        } ?? 0
        
        // self.addImagesInDocumentIndex(currentImageIndex)
        self.setCurrentImage (index: currentImageIndex)
        // imageData = imageRepos[currentImageIndex].data
        // self.selectedLayer.imageData = imageRepos[currentImageIndex].data
    }
    
    func setCurrentImage (index: Int) {
        // Create a new document if the current image index does not exist in the indexes database
        // otherwise we retrieve the position of the index in the indexes database, which is the position of the document where the image is opened
        // Then we select the corresponding document at the computed position
        currentImageIndex = index
        
        if !imagesInDocuments.contains(index) {
            createNewDocument()
            self.addImagesInDocumentIndex(currentImageIndex)
        } else {
            let pos = imagesInDocuments.firstIndex(of: index)!
            selectDocument(pos: pos)
        }

        imageData = imageRepos[currentImageIndex].data
        self.selectedLayer.imageData = imageRepos[currentImageIndex].data
    }
    
    @Published var imageRepos = [OnlineImage]()
    @Published var isFetchingImage: Bool = false
    private var reposSubscription = Set<AnyCancellable>()

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

    override init() {
        super.init()
        
        // compositions.append(document)

        // self.selectedLayer = addNewLayer(name: "Background")
        // _ = addNewLayer(name: "Layer 1")

        /*
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
         */
    }

    func fireChanges() {
        // showToolPicker()
        self.canvasUpdated.toggle()
        print("firechanges")
    }
}

///
/// Kakao login related extension
/// 
extension ModelData {
    func logout() {
        self.username = ""
        self.password = ""
        self.isLoggedIn = false
    }
    
    /*
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
        let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()

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
        let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        // naverInstance?.delegate = nil
        naverInstance?.delegate = self
        naverInstance?.requestThirdPartyLogin()
    }
    */
}

///
/// Handles editing related operations
///
extension ModelData {

    
    // updating the currently selected canvas
    func updateCurrentLayer() {
        // self.currentLayer().canvas.drawing = self.canvas.drawing
        self.selectedLayer.canvas.drawing.append(self.canvas.drawing)
        // print("Current layer")
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
        for l in currentDocument.DLayers {
            l.canvas.delegate = nil
        }
        */
        
        
        currentDocument.DLayers.append(layer)
        self.fireChanges()
        
        return layer
    }
    
    ///
    /// Adding new document witthout any layer
    ///
    func addNewDocument() {
        compositions.append(Composition())
        self.document = compositions.last!
        self.currentComposition = compositions.count - 1
    }
    
    ///
    ///
    ///
    func createNewDocument() {
        print("Creating a new document")
        
        compositions.append(Composition())
        self.document = compositions.last!
        self.currentComposition = compositions.count - 1
        
        self.selectedLayer = addNewLayer(name: "Background")
        
        self.currentComposition = compositions.count - 1
        self.selected = 0
        
        // print(currentComposition)
    }
    
    ///
    ///
    ///
    
    ///
    ///
    ///
    func removeDocument(_ pos: Int) {
        compositions.remove(at: pos)
        
        if compositions.count > 0 {
            selectDocument(pos:  (compositions.count > pos ) ? pos: pos - 1)
        }
    }
    
    ///
    ///
    ///
    func selectDocument(pos: Int) {
        self.currentComposition = pos
    }
    
    ///
    ///
    ///
    func currentLayer() -> DrawingLayer {
        return compositions[currentComposition].DLayers[selected]
    }
    
    ///
    ///
    ///
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
    
    ///
    ///
    ///
    func selectLayer(_ pos: Int) {
        selected = pos
    }

    func showToolPicker() {
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
    
    /*
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
    */
    
    ///
    /// Classifies the document as corrupted
    ///
    func corruptedDocument() {
        let doc = self.currentDocument
        
        guard let data = doc.DLayers[0].flatten()?.pngData() else {return}
        
        self.upload(key: String(imageRepos[currentImageIndex].key.components(separatedBy: "/").last ?? ""), data: data, isCorrupted: true) {
            print("deletion of objects")
            self.deleteObject(key: self.imageRepos[self.currentImageIndex].key)
        }
    }
    
    ///
    ///
    ///
    func saveCurrentDocument() {
        let doc = self.currentDocument
        
        guard let data = doc.DLayers[0].flatten()?.pngData() else {return}
        
        self.upload(key: String(imageRepos[currentImageIndex].key.components(separatedBy: "/").last ?? ""), data: data) {
            print("deletion of objects")
            self.deleteObject(key: self.imageRepos[self.currentImageIndex].key)
        }
    }
    
    ///
    /// Remove the data of the current image from the list images and closes the document using the image if any
    ///
    func updateImageRepository() {
        // Get the position of the index of the current image in the list of indexes
        // This position corresponds to the position of the document in which the image is opened
        // let pos = imagesInDocuments.firstIndex(of: currentImageIndex)
        imageRepos.remove(at: currentImageIndex) // Removes the image from the list of data
        self.removeImagesInDocumentIndex(currentImageIndex) // Remove the index of the image stored in the list of indexes of images already opened in a document

        if imageRepos.count > 0 {
            setCurrentImage(index: (imageRepos.count > currentImageIndex) ? currentImageIndex : currentImageIndex - 1)
        }else {   
            self.showDocument = false
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
    ///
    ///
    ///
    func upload(key: String = "", data: Data, isCorrupted:Bool =  false, completed: @escaping () -> Void) {
        
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
        
        var uploadKey = self.isLoggedIn ? "\(self.currentUserCompleteFolderKey)\(key)" : "complete/\(key)"
        
        if isCorrupted {
            uploadKey = self.isLoggedIn ? "\(self.currentUserCorruptedFolderKey)\(key)" : "corrupted/\(key)"
        }
        
        // Upload task
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data,
                                   bucket: "wedit-autocolor",
                                   key: uploadKey,
                                   contentType: "img/jpg",
                                   expression: expression,
                                   completionHandler: completionHandler)
            .continueWith {
                (task) -> AnyObject? in
            
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
            
                if let _ = task.result {
                    completed()
                }
            
                return nil
            }
    }

    ///
    ///
    ///
    func checkUser(username: String, pwd: String) {
        let s3 = AWSS3.default()
        self.username = username
        self.password = pwd
        
        do {
            try s3.listObjectsV2(AWSS3ListObjectsV2Request(dictionary: [
                "bucket": "wedit-autocolor",
                "prefix": self.currentUserOriginalFolderKey,
                "delimiter": "/"
            ], error: ())) {out, error in
                
                if error != nil {
                    print("An error occurred listing the buckets content", error!)
                    return
                }
                
                if out != nil {
                    guard let contents = out?.contents else {return}
                    
                    if contents.count > 0 && self.password == "\(self.username)12345" {
                        DispatchQueue.main.async {
                            self.isLoggedIn = true
                        }
                    }
                }
            }
        } catch {
            print("Error caught", error)
        }
    }
    
    ///
    /// Download a file from AWSS$ bucket
    ///
    func downloadData(key: String = "hdri.jpg") {
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            // Do something e.g. Update a progress bar.
            // print("Download in progress: ", Float(progress.fractionCompleted))
        })
        }

        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(
            fromBucket: "wedit-autocolor",
            key: "\(key)",
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
                    // self.selectedLayer.imageData = data
                    self.imageRepos.append(OnlineImage(key: key, data: data!))
                    // self.imageData = data ?? Data(count: 0)
                    self.fireChanges()
                    print("Task Completed", data!)
                }
            }
        }
    }
    
    ///
    ///
    ///
    func deleteObject(key: String = "original/film_03.jpg") {
        let s3 = AWSS3.default()
        
        do {
            try s3.deleteObject(AWSS3DeleteObjectRequest(dictionary:
                [
                    "bucket": "wedit-autocolor",
                    "key": key
                ], error: ())) {res, error  in
                
                if error == nil {
                    
                    DispatchQueue.main.async {
                        self.updateImageRepository()
                    }
                }
            }
        } catch {
            print("Error caught", error)
        }
        
    }
    
    ///
    ///
    ///
    func fetchDataFromCurrentList(_ count: Int = 25) {
        
        if !listKeys.hasReachedEnd {
            listKeys.next(count).result { res in
                res.forEach { key in
                    self.downloadData(key: key!)
                }
            }
        }
        
        self.allImagesLoaded = listKeys.hasReachedEnd
    }
    
    
    ///
    /// List 
    ///
    func listOriginals(fromCurrentUser: Bool = false) {
        /// Listing files
        if listKeys.isEmpty {
            let s3 = AWSS3.default()
            
            do {
                try s3.listObjectsV2(AWSS3ListObjectsV2Request(dictionary: [
                    "bucket": "wedit-autocolor",
                    "prefix": fromCurrentUser ? self.currentUserOriginalFolderKey: "original/",
                    "delimiter": "/"
                ], error: ())) {out, error in
                    
                    if error != nil {
                        print("An error occurred listing the buckets content", error!)
                        return
                    }
                    
                    if out != nil {
                        // print("Result", out!)
                        
                        guard let contents = out?.contents else {return}
                                            
                        let originals = contents[1..<contents.count].map {
                            $0.key
                        }.filter{
                            $0?.contains("original") ?? false
                        }
                        
                        DispatchQueue.main.async {
                            self.listKeys = RangedArray(data: originals)
                            
                            self.fetchDataFromCurrentList()
                        }
                    }
                }
            } catch {
                print("Error caught", error)
            }
        }else {
            fetchDataFromCurrentList()
        }
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
