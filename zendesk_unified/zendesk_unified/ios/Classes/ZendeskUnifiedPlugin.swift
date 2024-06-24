import Flutter
import UIKit

public class ZendeskUnifiedPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel
    
    // Init
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    // For platform view
    let factory = ZendeskNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "plugins.com.mrowl/zendesk_unified_view")
    let channel = FlutterMethodChannel(name: "plugins.com.mrowl/zendesk_unified", binaryMessenger: registrar.messenger())
    let instance = ZendeskUnifiedPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let zendeskApi = ZendeskApi(flutterPlugin: self, channel:channel)
    switch call.method {
    case "initialize":
        result(zendeskApi.initialize())
    case "setIdentity":
        let args = call.arguments as! [String: Any]
        let id = args["id"] as! String
        
        result(zendeskApi.setIdentity(email: id))
    case "showHelpCenter":
        
        result(zendeskApi.showHelpCenter())
    case "closeHelpCenter":
        result(zendeskApi.closeHelpCenter())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
