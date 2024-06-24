import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zendesk_unified_platform_interface/method_channel_zendesk_unified.dart';

abstract class ZendeskUnifiedPlatform extends PlatformInterface {
  ZendeskUnifiedPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZendeskUnifiedPlatform _instance = MethodChannelZendeskUnified();

  /// The default instance of [ZendeskUnifiedPlatform] to use.
  ///
  /// Defaults to [MethodChannelZendeskUnified].
  static ZendeskUnifiedPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ZendeskUnifiedPlatform] when they register themselves.
  static set instance(ZendeskUnifiedPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the Zendesk SDK
  Future<bool> initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Sets the user identity
  Future<bool> setIdentity({required String id}) {
    throw UnimplementedError('setIdentity() has not been implemented.');
  }

  /// Shows the help center
  Future<bool> showHelpCenter() {
    throw UnimplementedError('showHelpCenter() has not been implemented.');
  }

  /// closes the help center
  Future<bool> closeHelpCenter() {
    throw UnimplementedError('closeHelpCenter() has not been implemented.');
  }
}
