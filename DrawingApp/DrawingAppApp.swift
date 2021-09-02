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
import Amplify
import AWSCore
import AmplifyPlugins
import Combine
import AWSS3
import zlib

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
        print("It is initialized here")
        initializeAWSS3()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    modelData.initNaverSDK()
                    modelData.downloadData()
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
        // let access_key = "nWWEOZ3UWyHDYrlSrB3V"
        // let secret_key = "Yh4gMu6OlkKO6qnk5OlmVEPNqiTfY5CZrTqfRiPW"
        
        // let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .Unknown, identityPoolId: <#T##String#>)
        let credentialsProvider = MyCredentialsProvider()
        let serviceConfigureation = AWSServiceConfiguration(region: .APNortheast2, credentialsProvider: credentialsProvider)
        let _ = AWSServiceManager.default().defaultServiceConfiguration = serviceConfigureation
        
        /*
         Listing files
         let s3 = AWSS3.default()
        
        do {
            try s3.listObjectsV2(AWSS3ListObjectsV2Request(dictionary: ["bucket": "wedit-autocolor"], error: ())) {out, error in
                
                if error != nil {
                    print("An error occurred listing the buckets content", error!)
                    return
                }
                
                if out != nil {
                    print("Result", out!)
                }
            }
            
        } catch {
            print("Error caught", error)
        }
        */
        // print("List buckets", s3.listBuckets(AWSRequest()))
        /*
        do {
            Amplify.Logging.logLevel = .verbose
            
            
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
    
            try Amplify.add(plugin: AWSS3StoragePlugin())
            
            try Amplify.configure()
           
            print("Amplify configuration Done")
            
            // getTodo()
            
            
        } catch {
            print("An error occured setting up Amplify: \(error)")
        }
        */
        
        // upload()
        
        // downloadData()
        
        print("didFinishLaunchingWithOptions")
        
        return true
    }
}

func initializeAWSS3() {
    let credentialsProvider = MyCredentialsProvider()
    let serviceConfigureation = AWSServiceConfiguration(region: .APNortheast2, credentialsProvider: credentialsProvider)
    let _ = AWSServiceManager.default().defaultServiceConfiguration = serviceConfigureation
    
    /*
     Listing files
    let s3 = AWSS3.default()
    
    do {
        try s3.listObjectsV2(AWSS3ListObjectsV2Request(dictionary: ["bucket": "wedit-autocolor"], error: ())) {out, error in
            
            if error != nil {
                print("An error occurred listing the buckets content", error!)
                return
            }
            
            if out != nil {
                print("Result", out!)
            }
        }
        
    } catch {
        print("Error caught", error)
    }
    */
}

func upload() {
    let data: Data = Data() // Data to be uploaded
    
    let expression = AWSS3TransferUtilityUploadExpression()
    expression.progressBlock = { (task, progress) in
        DispatchQueue.main.async (execute: {
            print("Task in progress")
        })
    }
    
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    completionHandler = {(task, error) -> Void in
        DispatchQueue.main.async {
            print("Task Completed")
        }
    }
    
    let transferUtility = AWSS3TransferUtility.default()
    
    transferUtility.uploadData(data,
                               bucket: "wedit-autocolor",
                               key: "complete",
                               contentType: "text/plain",
                               expression: expression,
                               completionHandler: completionHandler).continueWith {
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

func downloadData() {
    
   let expression = AWSS3TransferUtilityDownloadExpression()
   expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
      // Do something e.g. Update a progress bar.

      })
   }

   var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
   completionHandler = { (task, URL, data, error) -> Void in
      DispatchQueue.main.async(execute: {
      // Do something e.g. Alert a user for transfer completion.
      // On failed downloads, `error` contains the error object.
          print("The transfer is completed")
      })
   }
    
    // transferUtility.

   let transferUtility = AWSS3TransferUtility.default()
   transferUtility.downloadData(
         fromBucket: "wedit-autocolor",
         key: "original/test_2.jpg",
         expression: expression // ,
         // completionHandler: completionHandler
   ) { (task, url, data, error) in
       if error != nil {
           print(error!)
           return
       }
       
       print("Url", url)
       print("Data", data!)
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


func getTodo () {
    let storageOperation = Amplify.Storage.downloadData(key: "original/test_2.jpg")
    let progressSink = storageOperation.progressPublisher.sink { progress in print("Progress: \(progress)") }
    let resultSink = storageOperation.resultPublisher.sink {
        if case let .failure(storageError) = $0 {
            print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
        }
    }
    receiveValue: { data in
        print("Completed: \(data)")
    }
}
