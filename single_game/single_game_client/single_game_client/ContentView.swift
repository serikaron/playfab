//
//  ContentView.swift
//  single_game_client
//
//  Created by serika on 2020/10/12.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("playFabID") var pfID = ""
    @AppStorage("sessionTicket") var ticket = ""
    @AppStorage("shouldLogin") var shouldLogin = true
    
    @State var value = ""

    @State var name = ""
    
    var body: some View {
        TextField("Enter...", text: $name)
        Text("your name: \(name)")
//        main.sheet(isPresented: $shouldLogin, content: {
//                LoginView(presenting: $shouldLogin) {
//                    self.pfID = $0
//                    self.ticket = $1
//                    self.shouldLogin = false
//                    print("id:\(self.pfID), ticket:\(ticket)")
//                }
//                .frame(height:50)
//                .padding(.horizontal, 50)
//            })
    }
    
    private var main: some View {
        VStack(spacing: 50) {
            Button(action: {
                PFHelper.Shared.Greetings("hello", sessionTicket: self.ticket)
            }) {
                Text("Greetings")
            }
            
            TextField("Value", text: $value)
            Button(action: {
                PFHelper.Shared.SetData(forKey: "TestKey", value: value, sessionTicket: self.ticket)
            }) {
                Text("SetData")
            }
            
            Button(action: {
                PFHelper.Shared.GetData(forKey: "TestKey", sessionTicket: self.ticket) { (value) in
                    print(value)
                }
            }) {
                Text("GetData")
            }
            
            Button(action: {
                self.shouldLogin = true
                self.pfID = ""
                self.ticket = ""
            }) {
                Text("Logout")
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
