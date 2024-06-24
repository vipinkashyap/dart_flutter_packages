import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zendesk_unified_platform_interface/method_channel_zendesk_unified.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelZendeskUnified', () {
    late MethodChannelZendeskUnified methodChannelZendeskUnified;
    setUp(() async {
      methodChannelZendeskUnified = MethodChannelZendeskUnified();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelZendeskUnified.channel,
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'initialize':
              return true;
            case 'setIdentity':
              return true;
            case 'showHelpCenter':
              return true;
            case 'closeHelpCenter':
              return true;
            default:
              throw MissingPluginException();
          }
        },
      );
    });

    test('initialize', () async {
      expect(await methodChannelZendeskUnified.initialize(), true);
    });

    test('setIdentity', () async {
      expect(await methodChannelZendeskUnified.setIdentity(id: 'id'), true);
    });

    test('showHelpCenter', () async {
      expect(await methodChannelZendeskUnified.showHelpCenter(), true);
    });

    test('closeHelpCenter', () async {
      expect(await methodChannelZendeskUnified.closeHelpCenter(), true);
    });
  });
}
