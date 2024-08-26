import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tinkoff_id_flutter_method_channel.dart';

abstract class TinkoffIdFlutterPlatform extends PlatformInterface {
  /// Constructs a TinkoffIdFlutterPlatform.
  TinkoffIdFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static TinkoffIdFlutterPlatform _instance = MethodChannelTinkoffIdFlutter();

  /// The default instance of [TinkoffIdFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelTinkoffIdFlutter].
  static TinkoffIdFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TinkoffIdFlutterPlatform] when
  /// they register themselves.
  static set instance(TinkoffIdFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init(String clientId, String redirectUri, bool debugIOS) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<bool> isTinkoffAuthAvailable() {
    throw UnimplementedError(
        'isTinkoffAuthAvailable() has not been implemented.');
  }

  Future<bool> handleCallbackUrl(String url) {
    throw UnimplementedError(
        'handleCallbackUrl() has not been implemented.');
  }

  Future startTinkoffAuth(String redirectUri) {
    throw UnimplementedError('startTinkoffAuth() has not been implemented.');
  }

  Future<Map<String, dynamic>> getTokenPayload(String incomingUri) {
    throw UnimplementedError(
        'getTinkoffTokenPayload() has not been implemented.');
  }

  Future<Map<String, dynamic>> updateToken(String refreshToken) {
    throw UnimplementedError('updateToken() has not been implemented.');
  }

  Future<bool> signOutByRefreshToken(String refreshToken) {
    throw UnimplementedError(
        'signOutByRefreshToken() has not been implemented.');
  }
}
