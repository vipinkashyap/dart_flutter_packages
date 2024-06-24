//
//  ZendeskNativeView.swift
//  zendesk_unified
//
//  Created by Vipin Kumar Kashyap on 2/13/24.
//
import Flutter
import UIKit
import ZendeskCoreSDK
import ChatProvidersSDK
import ChatSDK
import SupportSDK
import SupportProvidersSDK
import AnswerBotProvidersSDK
import AnswerBotSDK
import MessagingSDK
import MessagingAPI
import SDKConfigurations
import CommonUISDK

class ZendeskNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        // Zendesk Stuff
        Zendesk.initialize(
            appId: "f8380f76c0e35b78745541e47d42ff2aec56e8060db61ad9",
            clientId: "mobile_sdk_client_209cbb172ed1aa889e9c",
            zendeskUrl: "https://drowlhelp.zendesk.com"
            )
        Chat.initialize(accountKey: "46aXCQA8tOpP5VYxeTnuvhYCbZkYyDKU")
        Support.initialize(withZendesk: Zendesk.instance)
        AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)                   
        print("Zendesk initialized")
        // End Zendesk Stuff
        super.init()
    }


    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return ZendeskNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class ZendeskNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    // Add a property to hold the navigation controller
    var navigationController: UINavigationController?
    // Add a property to hold the messenger
    var messenger: FlutterBinaryMessenger?
    
    // Navigate back to the flutter portion of the app using method channels
    @objc func popBack() {
        guard let messenger = self.messenger else {
            print("Messenger is not set")
            return
        }
        let channel = FlutterMethodChannel(name: "plugins.com.mrowl/zendesk_unified", binaryMessenger: messenger)
        channel.invokeMethod("closeHelpCenter", arguments: [nil])
        print("Navigating back to Flutter")
    }
    
    // Create Native view : Fallback
    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.blue
        let nativeLabel = UILabel()
        nativeLabel.text = "Native text from iOS"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        _view.addSubview(nativeLabel)
    }
    


    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // Set the messenger
        self.messenger = messenger

        do {
            let messagingConfiguration = MessagingConfiguration()
            messagingConfiguration.name = "Answer Bot"
//            messagingConfiguration.isMultilineResponseOptionsEnabled = true

            var chatConfiguration: ChatConfiguration {
                let chatConfiguration = ChatConfiguration()
                chatConfiguration.isAgentAvailabilityEnabled = true
                chatConfiguration.isOfflineFormEnabled = true
                chatConfiguration.isPreChatFormEnabled = true
                chatConfiguration.chatMenuActions = [.endChat]
                return chatConfiguration
            }

            let answerBotEngine = try AnswerBotEngine.engine()
            let supportEngine = try SupportEngine.engine()
            let chatEngine = try ChatEngine.engine()

            let anonymousIdentity = Identity.createAnonymous()
            Zendesk.instance?.setIdentity(anonymousIdentity)
            print("User identity set.")
            
            // Styling
            CommonTheme.currentTheme.primaryColor = .systemGreen
            UINavigationBar.appearance().barTintColor = .systemGreen
            
            // View Controller
            let messagingViewController = try Messaging.instance.buildUI(
                engines: [
                    answerBotEngine,
                    chatEngine,
                    supportEngine
                ],
                configs: [messagingConfiguration, chatConfiguration]
            )
            
            // Create a UINavigationController with messagingViewController as the root view controller
             self.navigationController = UINavigationController(rootViewController: messagingViewController)

             // Add a back button to the navigation bar
            messagingViewController.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "X", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popBack))
            messagingViewController.navigationItem.leftBarButtonItem = newBackButton
            

            // Set the navigation bar's appearance
            self.navigationController?.navigationBar.barTintColor = .systemGreen
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.tintColor = .white // This changes the color of the back button

            // Set the title and subtitle
            messagingViewController.title = "DrOwl Help Desk"
            messagingViewController.navigationItem.prompt = "Live Chat w/DrOwl Agents M-F 9am-5pm MST"
            
            // Add the navigation controller's view to _view
            if let navigationControllerView = self.navigationController?.view {
                _view.addSubview(navigationControllerView)
                navigationControllerView.frame = _view.bounds
            }

            
        } catch {
            self.createNativeView(view: _view) 
            print("Error in ZendeskNativeView init: \(error.localizedDescription)")
        }
    }

    func view() -> UIView {
        return _view
    }

}
