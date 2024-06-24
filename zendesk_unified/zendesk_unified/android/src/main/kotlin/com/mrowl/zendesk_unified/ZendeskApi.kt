package com.mrowl.zendesk_unified

import zendesk.core.Zendesk;
import zendesk.support.Support;
import zendesk.support.SupportEngine
import zendesk.answerbot.AnswerBot;
import zendesk.answerbot.AnswerBotEngine
import zendesk.core.AnonymousIdentity
import zendesk.core.Identity
import zendesk.chat.Chat
import zendesk.chat.ChatEngine
import zendesk.classic.messaging.MessagingActivity
import io.flutter.plugin.common.MethodChannel


// Want this class to have a parameter that is a MethodChannel object


class ZendeskApi(private val plugin: ZendeskUnifiedPlugin, private val channel: MethodChannel){
    // Data variables
    private val zendeskUrl = "https://drowlhelp.zendesk.com"
    private val appId = "f8380f76c0e35b78745541e47d42ff2aec56e8060db61ad9"
    private val clientId = "mobile_sdk_client_209cbb172ed1aa889e9c"

    // Methods
    // Initialize Zendesk
    // Takes a Registrar object as a parameter
    // Returns a boolean value
     fun initialize(): Boolean {
         Zendesk.INSTANCE.init(plugin.activity!! , zendeskUrl, appId, clientId)
         Support.INSTANCE.init(Zendesk.INSTANCE)
        AnswerBot.INSTANCE.init(Zendesk.INSTANCE, Support.INSTANCE);
        Chat.INSTANCE.init(plugin.activity!!, "46aXCQA8tOpP5VYxeTnuvhYCbZkYyDKU");
        return true
     }

    // Set an anonymous identity
    // Takes no parameters
    // Returns a boolean value
    fun setAnonymousIdentity(): Boolean {
        val identity: Identity = AnonymousIdentity.Builder().withNameIdentifier("test name").build();
        Zendesk.INSTANCE.setIdentity(identity);
        return true
    }

    // Show the help center
    fun showHelpCenter(): Boolean {
        var context = plugin.activity!!
        val answerBotEngine = AnswerBotEngine.engine();
        val supportEngine = SupportEngine.engine();
        val chatEngine = ChatEngine.engine();

        MessagingActivity.builder()
                .withBotLabelString("Answer Bot")
                .withEngines(answerBotEngine, chatEngine, supportEngine)
                .show(context);
        return true

    }
}