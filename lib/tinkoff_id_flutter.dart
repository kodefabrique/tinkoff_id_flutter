import 'package:flutter/services.dart';
import 'package:tinkoff_id_flutter/entities/token_payload.dart';

import 'hidden/tinkoff_id_flutter_platform_interface.dart';

///Object with which you can manage the login via Tinkoff ID SDK.
class TinkoffIdFlutter {
  ///Method for SDK initialization. No exceptions throws.
  Future<void> init(String clientId, String redirectUri, bool debugIOS) =>
      TinkoffIdFlutterPlatform.instance.init(clientId, redirectUri, debugIOS);

  ///Checks if the Tinkoff Bank application is installed. No exceptions throws.
  Future<bool> isTinkoffAuthAvailable() =>
      TinkoffIdFlutterPlatform.instance.isTinkoffAuthAvailable();

  ///Launches the Tinkoff Bank application, where the user enters authorization data. No exceptions throws
  Future startTinkoffAuth(String redirectUri) =>
      TinkoffIdFlutterPlatform.instance.startTinkoffAuth(redirectUri);

  ///Trying get tokens from an incoming link from the Tinkoff Bank application. Throws [PlatformException]
  Future<TokenPayload> getTokenPayload(String incomingUri) =>
      TinkoffIdFlutterPlatform.instance
          .getTokenPayload(incomingUri)
          .then((value) => TokenPayload.fromJson(value));

  ///Gets new tokens by the refresh token. Throws [PlatformException]
  Future<TokenPayload> updateToken(String refreshToken) {
    return TinkoffIdFlutterPlatform.instance
        .updateToken(refreshToken)
        .then((value) => TokenPayload.fromJson(value));
  }

  ///Logs out of the Tinkoff ID system using the refresh token. No exceptions throws.
  Future<bool> signOutByRefreshToken(String refreshToken) =>
      TinkoffIdFlutterPlatform.instance.signOutByRefreshToken(refreshToken);
}
