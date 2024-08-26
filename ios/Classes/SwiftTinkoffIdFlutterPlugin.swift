import Flutter
import UIKit

public class SwiftTinkoffIdFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tinkoff_id_flutter", binaryMessenger: registrar.messenger())
    let backgroundChannel = FlutterMethodChannel(name: "tinkoff_id_flutter_background", binaryMessenger: registrar.messenger(), codec: FlutterStandardMethodCodec.sharedInstance())
    let instance = SwiftTinkoffIdFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addMethodCallDelegate(instance, channel:backgroundChannel)
  }


  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let arguments = call.arguments as! Dictionary<String, Any>
      switch call.method {
      case "init":
          initTinkoff(clientId: arguments["clientId"] as! String, redirectUri: arguments["redirectUri"] as! String, debug: arguments["debugIOS"] as! Bool, result: result)
      case "isTinkoffAuthAvailable":
          isTinkoffAuthAvailable(result:result)
      case "handleCallbackUrl":
          handleCallbackUrl(url: arguments["url"] as! String, result:result)
      case "startTinkoffAuth":
          startTinkoffAuth(result: result)
      //case "getTinkoffTokenPayload":
              //getTinkoffTokenPayload( incomingUri: arguments["incomingUri"] as! String, //result: result)
      case "updateToken": updateToken(refreshToken: arguments["refreshToken"] as! String, result: result)
      case "signOutByRefreshToken": signOutByRefreshToken(refreshToken: arguments["refreshToken"] as! String, result:result)
      default:
          result(FlutterMethodNotImplemented)
      }
  }
}
