//
//  GGApp.swift
//  GG
//
//  Created by Adlet Kanatbek on 12/11/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct GGApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var legalStore = LegalStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(legalStore)
                .onAppear {
                    legalStore.fetchLegalTexts()
                }
        }
    }
}
