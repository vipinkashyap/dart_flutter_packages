import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZendeskView extends StatelessWidget {
  const ZendeskView({super.key});

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'plugins.com.mrowl/zendesk_unified_view';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'id': 'vipin@123.com'
    };

    if (Platform.isAndroid) {
      return AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) => _onPlatformViewCreated(id, context));
    } else {
      return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) => _onPlatformViewCreated(id, context));
    }
  }

  _onPlatformViewCreated(int id, BuildContext context) {
    log('Platform view created');

    // Set up method channel for communication
    const MethodChannel('plugins.com.mrowl/zendesk_unified')
        .setMethodCallHandler((call) async {
      if (call.method == 'closeHelpCenter') {
        // Handle callback from platform view
        log('Received callback from platform view');
        // Pop
        Navigator.of(context).pop();
      }
    });
  }
}
