import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tinkoff_id_flutter/hidden/tinkoff_id_flutter_method_channel.dart';
import 'package:tinkoff_id_flutter/hidden/tinkoff_id_flutter_platform_interface.dart';

class MockTinkoffIdFlutterPlatform with MockPlatformInterfaceMixin implements TinkoffIdFlutterPlatform {
  @override
  Future<void> init(String clientId, String redirectUri, bool debugIOS) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<bool> isTinkoffAuthAvailable() {
    // TODO: implement isTinkoffAuthAvailable
    throw UnimplementedError();
  }

  @override
  Future startTinkoffAuth(String redirectUri) {
    // TODO: implement startTinkoffAuth
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getTokenPayload(String url) {
    // TODO: implement getTinkoffTokenPayload
    throw UnimplementedError();
  }

  @override
  Future<bool> signOutByRefreshToken(String refreshToken) {
    // TODO: implement signOutByRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> updateToken(String refreshToken) {
    // TODO: implement updateToken
    throw UnimplementedError();
  }
}

void main() {
  final TinkoffIdFlutterPlatform initialPlatform = TinkoffIdFlutterPlatform.instance;

  test('$MethodChannelTinkoffIdFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTinkoffIdFlutter>());
  });
}
