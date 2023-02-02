import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tinkoff_id_flutter_platform_interface.dart';

/// An implementation of [TinkoffIdFlutterPlatform] that uses method channels.
class MethodChannelTinkoffIdFlutter extends TinkoffIdFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tinkoff_id_flutter');

  /// The background method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannelBackground = const MethodChannel('tinkoff_id_flutter_background');

  @override
  Future<void> init(String clientId, String redirectUri, bool debugIOS) async => await methodChannel.invokeMethod('init', {
        "clientId": clientId,
        "redirectUri": redirectUri,
        "debugIOS": debugIOS,
      });

  @override
  Future<bool> isTinkoffAuthAvailable() async => await methodChannel.invokeMethod('isTinkoffAuthAvailable', {});

  @override
  Future startTinkoffAuth(String redirectUri) async =>
      await methodChannel.invokeMethod('startTinkoffAuth', {"redirectUri": redirectUri});

  @override
  Future<Map<String, dynamic>> getTokenPayload(String incomingUri) => methodChannelBackground
      .invokeMapMethod<String, dynamic>('getTinkoffTokenPayload', {"incomingUri": incomingUri}).then((value) => value!);

  @override
  Future<Map<String, dynamic>> updateToken(String refreshToken) => methodChannelBackground
      .invokeMapMethod<String, dynamic>('updateToken', {"refreshToken": refreshToken}).then((value) => value!);

  @override
  Future<bool> signOutByRefreshToken(String refreshToken) =>
      methodChannelBackground.invokeMethod('signOutByRefreshToken', {"refreshToken": refreshToken}).then((value) => value!);
}
