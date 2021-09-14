//
//  DrawingAppApp.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/08.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin
import AWSCore
import Combine
import AWSS3

@main
struct DrawingAppApp: App {
    // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared
    @StateObject var modelData = ModelData()
    // Naver login instance
    // let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    init() {
        // Initialize Kakao SDK.
        KakaoSDKCommon.initSDK(appKey: "468d7e5a837f342c18b3f2a6b63df60d")
        initializeAWSS3()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    modelData.initNaverSDK()
                    // modelData.deleteObject()
                    // modelData.downloadData()
                    // modelData.listOriginals()
                })
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(modelData)
                .onOpenURL(perform: {url in
                    
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        AuthController.handleOpenUrl(url: url)
                    }
                    
                    if NaverThirdPartyLoginConnection.isNaverThirdPartyLoginAppschemeURL(modelData.naverInstance!)(url) {
                        modelData.naverInstance?.receiveAccessToken(url)
                    }
                    // NaverThirdPartyLoginConnection.isNaverThirdPartyLoginAppschemeURL(naverInstance)
                })
        }
    }
}

///Lal
/// App delegates
///

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let credentialsProvider = MyCredentialsProvider()
        let serviceConfigureation = AWSServiceConfiguration(region: .APNortheast2, credentialsProvider: credentialsProvider)
        let _ = AWSServiceManager.default().defaultServiceConfiguration = serviceConfigureation
    
        /*
        do {
            Amplify.Logging.logLevel = .verbose
            
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
    
            try Amplify.add(plugin: AWSS3StoragePlugin())
            
            try Amplify.configure()
            
        } catch {
            print("An error occured setting up Amplify: \(error)")
        }
        */

        print("didFinishLaunchingWithOptions")
        
        return true
    }
}

func initializeAWSS3() {
    let credentialsProvider = MyCredentialsProvider()
    let serviceConfigureation = AWSServiceConfiguration(region: .APNortheast2, credentialsProvider: credentialsProvider)
    let _ = AWSServiceManager.default().defaultServiceConfiguration = serviceConfigureation
}
