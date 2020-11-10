//
//  FBHelper.swift
//  single_game_client
//
//  Created by serika on 2020/10/13.
//

import Foundation
import FacebookLogin
import SwiftUI

struct LoginButton : UIViewRepresentable {
    
    var onLogin : (_ tokenString: String) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.delegate = context.coordinator
        button.permissions = ["public_profile", "email"]
        button.removeConstraints(button.constraints)
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        
        var parent : LoginButton
        init(parent: LoginButton) {
            self.parent = parent
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if result!.isCancelled {
                return
            }
            
            guard let tokenString = AccessToken.current?.tokenString else {
                print("Access Token Invalid")
                return
            }
            
            self.parent.onLogin(tokenString)
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        }
    }
}


