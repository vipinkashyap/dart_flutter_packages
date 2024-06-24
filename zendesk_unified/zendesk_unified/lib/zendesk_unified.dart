import 'package:zendesk_unified_platform_interface/zendesk_unified_platform_interface.dart'
    show ZendeskUnifiedPlatform;

class ZendeskUnified {
  // Singleton
  static final ZendeskUnified _instance = ZendeskUnified._internal();
  factory ZendeskUnified() => _instance;
  ZendeskUnified._internal();

  static ZendeskUnifiedPlatform get _platform {
    return ZendeskUnifiedPlatform.instance;
  }

  Future<bool> init() {
    return _platform.initialize();
  }

  Future<bool> setIdentity({required String id}) {
    return _platform.setIdentity(id: id);
  }

  Future<bool> showHelpCenter() {
    return _platform.showHelpCenter();
  }

  Future<bool> closeHelpCenter() {
    return _platform.closeHelpCenter();
  }
}
