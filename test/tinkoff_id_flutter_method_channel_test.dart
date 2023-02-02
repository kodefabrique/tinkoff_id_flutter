import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tinkoff_id_flutter/hidden/tinkoff_id_flutter_method_channel.dart';

void main() {
  MethodChannelTinkoffIdFlutter platform = MethodChannelTinkoffIdFlutter();
  const MethodChannel channel = MethodChannel('tinkoff_id_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
