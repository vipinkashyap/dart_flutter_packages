//  Created by Vipin Kumar Kashyap on 2/13/24.

import UIKit
import Flutter
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



public class ZendeskApi:NSObject {
    // Declare
    private var zendeskPlugin: ZendeskUnifiedPlugin? = nil
    private var channel: FlutterMethodChannel? = nil
    private var navigationController: UINavigationController? = nil
    private var rootViewController: UIViewController? = nil
    
    // Initialize
    init(flutterPlugin: ZendeskUnifiedPlugin, channel: FlutterMethodChannel) {
        self.zendeskPlugin = flutterPlugin
        self.channel = channel
    }
    
    func initialize()  -> Bool {
        Zendesk.initialize(appId: "f8380f76c0e35b78745541e47d42ff2aec56e8060db61ad9",
                           clientId: "mobile_sdk_client_209cbb172ed1aa889e9c",
                           zendeskUrl: "https://drowlhelp.zendesk.com")
        Chat.initialize(accountKey: "46aXCQA8tOpP5VYxeTnuvhYCbZkYyDKU")
        Support.initialize(withZendesk: Zendesk.instance)
        // Initialize Answer Bot with instances of Zendesk and Support singletons
        guard let support = Support.instance else { return false }
        AnswerBot.initialize(withZendesk: Zendesk.instance, support: support)
        return true
    }

    // Set Identity
    func setIdentity(email: String) -> Bool {
        let anonymousIdentity = Identity.createAnonymous(email: email)
        Zendesk.instance?.setIdentity(anonymousIdentity)
        return true
    }

    // Show Help Center
    
    func showHelpCenter() -> Bool {
         CommonTheme.currentTheme.primaryColor = .systemGreen
         UINavigationBar.appearance().barTintColor = .systemGreen
        // UINavigationBar.appearance().tintColor = .white
        // UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]


        
        
        do {
            let messagingConfiguration = MessagingConfiguration()
            messagingConfiguration.name = "Dr Owl"
            messagingConfiguration.isMultilineResponseOptionsEnabled = true
            
            
            
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

            // Get the root view controller
            rootViewController = UIApplication.shared.delegate?.window??.rootViewController
            // Build the messaging screen
            let messagingViewController = try Messaging.instance.buildUI(
                engines: [
                answerBotEngine,
                chatEngine,
                supportEngine
            ],
            configs: [messagingConfiguration, chatConfiguration]
            )
        // Set the title and subtitle
        messagingViewController.title = "DrOwl Help Desk"
        messagingViewController.navigationItem.prompt = "Live Chat w/DrOwl Agents M-F 9am-5pm MST"

        // Create a close button
        let closeButton = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(closeHelpCenter))
        closeButton.tintColor = UIColor.white
        closeButton.isEnabled = true
        

        if #available(iOS 13.0, *) {
            if #available(iOS 14.0, *) {
                closeButton.primaryAction = UIAction { action in
                    self.closeHelpCenter()
                }
            } else {
                // Fallback on earlier version
            }
        } else {
            // Handle this
        }
            
        
        // Set the close button as the right bar button item
//        messagingViewController.navigationItem.leftBarButtonItem = closeButton
        // Create a navigation controller
        navigationController = UINavigationController(rootViewController: messagingViewController)
//        navigationController?.modalPresentationStyle = .fullScreen


        // Customize the navigation bar
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor.green // replace with your light green color
        navigationBar?.isTranslucent = false
        navigationBar?.backgroundColor = UIColor.green
        navigationBar?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        navigationBar?.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        navigationBar?.topItem?.setLeftBarButton(closeButton, animated: true)
            // Present the messaging screen
                rootViewController?.present(navigationController!, animated: true, completion: nil)
            return true
        } catch {
            // Send this back to Flutter
            // Log the error
            print("Error: \(error.localizedDescription)")
            
            return false
        }
    }


    // Close Help Center
    @objc func closeHelpCenter()  -> Bool  {
    print("closeHelpCenter called") // Debug print statement

    // Logout and clear the identity
    Chat.instance?.resetIdentity(nil)
    print("Working close...")

    // Get the root view controller
    // let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
    // rootViewController?.dismiss(animated: true)
    if let rootViewController = self.rootViewController {
        print("Root view controller: \(rootViewController)") // Debug print statement
        rootViewController.dismiss(animated: true, completion: nil)
    } else {
        print("Root view controller is nil") // Debug print statement
    }

    // Dismiss the messaging screen
    // self.navigationController?.popViewController(animated: true)
    // self.navigationController?.dismiss(animated: true, completion: nil)
    return true
    }
}
