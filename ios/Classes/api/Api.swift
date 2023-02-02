//
//  api.swift
//  Runner
//
//  Created by Andrey Vazhenin
//

import Foundation
import TinkoffID
import Flutter

var tinkoffId: ITinkoffID? = nil
var getPayloadResult: FlutterResult? = nil

func initTinkoff(clientId: String, redirectUri: String, debug: Bool, result: FlutterResult) {
    if(debug) {
        let debugConfiguration = DebugConfiguration(canRefreshTokens: true, canLogout: true)
        let debugFactory = DebugTinkoffIDFactory(callbackUrl: redirectUri, configuration: debugConfiguration)
        tinkoffId = debugFactory.build()
    } else {
        let factory = TinkoffIDFactory(clientId: clientId, callbackUrl: redirectUri)
        tinkoffId = factory.build()
    }
    result(nil)
}

func isTinkoffAuthAvailable( result: FlutterResult) {
    result(tinkoffId?.isTinkoffAuthAvailable ?? false)
}

func startTinkoffAuth(result: FlutterResult) {
    tinkoffId?.startTinkoffAuth{ resultLocal in
        do {
            let  tokenPayload = try resultLocal.get()
            let dict : [String: Any] = ["accessToken": tokenPayload.accessToken,"refreshToken": tokenPayload.refreshToken ?? "", "idToken": tokenPayload.idToken, "expiresIn": Int(tokenPayload.expirationTimeout)]
            getPayloadResult!(dict)
        } catch {
            getPayloadResult!(FlutterError(code: "getTinkoffTokenPayload",
                                           message: error.localizedDescription,
                                           details: nil))
        }
    }
    result(nil)
}

func getTinkoffTokenPayload(incomingUri: String, result: @escaping FlutterResult) {
    getPayloadResult = result
    let incomingURL = URL(string: incomingUri)
    if(incomingURL == nil) {
        getPayloadResult!(FlutterError(code: "getTinkoffTokenPayload",
                                       message: "Parsing incoming link failed.",
                                       details: nil))
        return
    }
    
    let success =   tinkoffId!.handleCallbackUrl(incomingURL!)
    if(!success){
        getPayloadResult!(FlutterError(code: "getTinkoffTokenPayload",
                                       message: "Handling incoming link failed.",
                                       details: nil))
    }
}

func updateToken(refreshToken: String, result: @escaping FlutterResult) {
    tinkoffId!.obtainTokenPayload(using: refreshToken) { r in
        do {
            let tokenPayload = try r.get()
            let dict : [String: Any] = ["accessToken": tokenPayload.accessToken,"refreshToken": tokenPayload.refreshToken ?? "", "idToken": tokenPayload.idToken, "expiresIn": Int(tokenPayload.expirationTimeout)]
            result(dict)
        } catch {
            result(FlutterError(code: "updateToken",
                                           message: error.localizedDescription,
                                           details: nil))
        }
    }
}

func signOutByRefreshToken(refreshToken:String, result: @escaping FlutterResult){
    tinkoffId!.signOut(with: refreshToken, tokenTypeHint: .refresh) {r in
        do {
            _ = try r.get()
            result(true)
        } catch  {
            result(false)
        }
    }
}
