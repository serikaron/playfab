//
//  playfab_loginApp.swift
//  playfab-login
//
//  Created by serika on 2020/9/23.
//

import SwiftUI
import FBSDKCoreKit

@main
struct playfab_loginApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    print(url)
                    ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue, annotation: UIApplication.OpenURLOptionsKey.annotation)
                })
        }
    }
}
