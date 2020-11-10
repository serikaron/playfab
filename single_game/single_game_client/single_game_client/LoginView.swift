//
//  LoginView.swift
//  single_game_client
//
//  Created by serika on 2020/10/13.
//

import SwiftUI

struct LoginView: View {
    @Binding var presenting : Bool
    
    let onPlayFabLogin : LoginCallback
    
    var body: some View {
        LoginButton() { tokenString in
            PFHelper.Shared.FBLoginWith(tokenString: tokenString, callback: self.onPlayFabLogin)
            self.presenting = false
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
