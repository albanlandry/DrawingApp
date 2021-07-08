//
//  DrawingAppApp.swift
//  DrawingApp
//
//  Created by 케이넷이엔지 on 2021/07/08.
//

import SwiftUI

@main
struct DrawingAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
