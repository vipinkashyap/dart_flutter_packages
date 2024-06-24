import 'dart:developer';

import 'package:flutter/services.dart';

import 'zendesk_unified_platform_interface.dart';

/// An implementation of [ZendeskUnifiedPlatform] that uses method channels.
class MethodChannelZendeskUnified extends ZendeskUnifiedPlatform {
  MethodChannel channel =
      const MethodChannel('plugins.com.mrowl/zendesk_unified');
  @override
  Future<bool> initialize() async {
    return await channel.invokeMethod('initialize').then((value) {
      log('initialize: $value');
      return value as bool;
    }).catchError((e) {
      log('initialize error: $e');
      return false;
    });
  }

  @override
  Future<bool> setIdentity({required String id}) async {
    return await channel.invokeMethod('setIdentity', {'id': id}).then((value) {
      log('setIdentity: $value');
      return value as bool;
    }).catchError((e) {
      log('setIdentity error: $e');
      return false;
    });
  }

  @override
  Future<bool> showHelpCenter() async {
    return await channel.invokeMethod('showHelpCenter').then((value) {
      log('showHelpCenter: $value');
      return value as bool;
    }).catchError((e) {
      log('showHelpCenter error: $e');
      return false;
    });
  }

  @override
  Future<bool> closeHelpCenter() async {
    return await channel.invokeMethod('closeHelpCenter').then((value) {
      log('closeHelpCenter: $value');
      return value as bool;
    }).catchError((e) {
      log('closeHelpCenter error: $e');
      return false;
    });
  }
}
