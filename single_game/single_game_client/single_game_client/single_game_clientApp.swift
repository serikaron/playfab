//
//  single_game_clientApp.swift
//  single_game_client
//
//  Created by serika on 2020/10/12.
//

import SwiftUI
import FBSDKCoreKit

@main
struct single_game_clientApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue, annotation: UIApplication.OpenURLOptionsKey.annotation)
                })
        }
    }
}
