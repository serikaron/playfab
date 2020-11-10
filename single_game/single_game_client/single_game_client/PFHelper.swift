//
//  PFHelper.swift
//  single_game_client
//
//  Created by serika on 2020/10/13.
//

import SwiftUI
import Alamofire

typealias LoginCallback = (_ playFabID: String, _ sessionTicket: String) -> Void
typealias ResponseData = [String: Any]

class PFHelper {
    static let Shared = PFHelper()
    
    let titleID = "512C4"
    
    func FBLoginWith(tokenString: String, callback: @escaping LoginCallback) {
        let param = PlayFabLoginBody(AccessToken: tokenString, TitleId: titleID, CreateAccount: true)
        
        AF.request("https://512C4.playfabapi.com/Client/LoginWithFacebook", method: .post, parameters: param, encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                guard let data = json["data"] as? [String: Any] else { return }
                guard let pfID = data["PlayFabId"] as? String else { return }
                guard let sessionTicket = data["SessionTicket"] as? String else { return }
                callback(pfID, sessionTicket)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func Greetings(_ msg: String, sessionTicket: String) {
        executeCloudScript(sessionTicket:sessionTicket, functionName: "helloWorld", functionParameter: FunctionParameter(inputValue: msg))
    }
    
    func SetData(forKey: String, value: String, sessionTicket: String) {
        executeCloudScript(sessionTicket:sessionTicket, functionName: "setPlayerData", functionParameter: FunctionParameter(playerDataKey: forKey, playerDataValue: value))
    }
    
    func GetData(forKey: String, sessionTicket: String, handler: (_ value: String)->Void) {
//        executeCloudScript(sessionTicket: sessionTicket, functionName: "getPlayerData", functionParameter: FunctionParameter(playerDataKey: forKey))
//        switch response.result {
//        case .success(let value):
//            guard let json = value as? ResponseData else { return }
//            guard let data = json["data"] as? ResponseData else { return }
//            guard let functionResult = data["FunctionResult"] as? ResponseData else { return }
//            guard let resultData = functionResult["Data"] as? ResponseData else { return }
//            guard let valudData = resultData[
//            callback(pfID, sessionTicket)
//        case .failure(let error):
//            print(error)
//        }
    }
    
    private func requestURLWith(call: String) -> String {
        return "https://\(titleID).playfabapi.com/Client/\(call)"
    }
    
    private func dataFrom(response : AFDataResponse<Any>) -> ResponseData? {
        switch response.result {
        case .success(let value):
            guard let json = value as? ResponseData else { return nil }
            guard let data = json["data"] as? ResponseData else { return nil }
//            completion(data)
            print(data)
        case .failure(let error):
            print(error)
        }
        return nil
    }
    
    private func executeCloudScript(sessionTicket: String, functionName: String, functionParameter: FunctionParameter? = nil, genEvent: Bool = false, completion: (_ data : [String: Any]?) -> Void = {d in}) {
        let headers: HTTPHeaders = [
            "X-Authorization": sessionTicket
        ]
        
        let body = ExecuteCloudScriptBody(FunctionName: functionName, GeneratePlayStreamEvent: genEvent, FunctionParameter: functionParameter)

        AF.request(requestURLWith(call: "ExecuteCloudScript"), method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
//            debugPrint(response)

        }
    }
}

struct FunctionParameter : Codable {
    var inputValue: String? = nil
    var playerDataKey: String? = nil
    var playerDataValue: String? = nil
}

struct ExecuteCloudScriptBody : Codable {
    let FunctionName : String
    let GeneratePlayStreamEvent : Bool
    var FunctionParameter : FunctionParameter? = nil
}

struct PlayFabLoginBody : Codable {
    let AccessToken : String
    let TitleId : String
    let CreateAccount : Bool
}
