//
//  api.swift
//  Runner
//
//  Created by Andrey Vazhenin
//

import Foundation
import TID
import Flutter

var tinkoffId: ITID? = nil
var getPayloadResult: FlutterResult? = nil

func initTinkoff(clientId: String, redirectUri: String, debug: Bool, result: FlutterResult) {
    if(debug) {
        let debugConfiguration = DebugConfiguration(canRefreshTokens: true, canLogout: true)
        let debugFactory = DebugTIDFactory(callbackUrl: redirectUri, configuration: debugConfiguration)
        tinkoffId = debugFactory.build()
    } else {
        let factory = TIDFactory(
            clientId: clientId,
            callbackUrl: redirectUri
        )
        tinkoffId = factory.build()
    }
    result(nil)
}

func isTinkoffAuthAvailable( result: FlutterResult) {
    result(tinkoffId?.isTAuthAvailable ?? false)
}

func handleCallbackUrl(url: String, result: FlutterResult) {
    tinkoffId?.handleCallbackUrl(URL(string: url)!)
}
func startTinkoffAuth(result: @escaping FlutterResult) {
    tinkoffId?.startTAuth { resultLocal in
        do {
            let tokenPayload = try resultLocal.get()
            let dict: [String: Any] = [
                "accessToken": tokenPayload.accessToken,
                "refreshToken": tokenPayload.refreshToken ?? "",
                "idToken": tokenPayload.idToken,
                "expiresIn": Int(tokenPayload.expirationTimeout)
            ]
            result(dict)
        } catch let error as TAuthError {
            switch error {
            case .cancelledByUser:
                result(FlutterError(code: "getTinkoffTokenPayload",
                                                message: "Login canceled by user",
                                                details: nil)),
            case .failedToObtainToken:
                result(FlutterError(code: "getTinkoffTokenPayload",
                                               message: "Authorization could not be completed after returning from the app",
                                               details: nil))
            default:
                result(FlutterError(code: "getTinkoffTokenPayload",
                                    message: error.localizedDescription,
                                    details: nil))
            }
        } catch {
            result(FlutterError(code: "getTinkoffTokenPayload",
                                message: error.localizedDescription,
                                details: nil))
        }
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
