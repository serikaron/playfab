//
//  ContentView.swift
//  playfab-login
//
//  Created by serika on 2020/9/23.
//

import SwiftUI
import FacebookLogin
import Alamofire

struct PlayFabLoginBody : Codable {
    let AccessToken : String
    let TitleId : String
    let CreateAccount : Bool
}

struct ContentView: View {
    @AppStorage("otherName") var logged = false
    @AppStorage("id") var id = ""
    @AppStorage("email") var email = ""
    @AppStorage("name") var name = ""
    
    var body: some View {
        VStack(spacing: 50) {
            LoginButton(logged: $logged, id: $id, email: $email, name: $name)
                .frame(height: 50)
                .padding(.horizontal, 25)
            Text("id: \(id)")
            Text("email: \(email)")
            Text("name: \(name)")
        }
    }
}

struct LoginButton : UIViewRepresentable {
    
    @Binding var logged : Bool
    @Binding var id : String
    @Binding var email : String
    @Binding var name : String
    
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
                        
            let req = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
            req.start { (response, result, error) in
                guard let r = result as? [String:String] else {
                    self.parent.logged = false
                    self.parent.id = ""
                    self.parent.email = ""
                    self.parent.name = ""
                    return
                }
                
                self.parent.logged = true
                self.parent.id = r["id"] ?? ""
                self.parent.email = r["email"] ?? ""
                self.parent.name = r["name"] ?? ""
                
                let param = PlayFabLoginBody(AccessToken: tokenString, TitleId: "512C4", CreateAccount: true)
                
                AF.request("https://512C4.playfabapi.com/Client/LoginWithFacebook", method: .post, parameters: param, encoder: JSONParameterEncoder.default).response { response in
                    debugPrint(response)
                }
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            self.parent.logged = false
            self.parent.id = ""
            self.parent.email = ""
            self.parent.name = ""
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
