import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zendesk_unified/zendesk_unified.dart';
import 'package:zendesk_unified_example/views/views.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Zendesk Unified Example',
            textScaler: TextScaler.linear(1.2),
            overflow: TextOverflow.ellipsis,
          )),
      body: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _zendeskUnifiedPlugin = ZendeskUnified();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: Platform.isIOS,
            child: ElevatedButton(
              key: const Key('zendesk_native_view'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ZendeskView()));
              },
              child: const Text(
                'Platform View',
                textScaler: TextScaler.linear(1.4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('zendesk'),
            onPressed: () async {
              try {
                final isInitialized = await _zendeskUnifiedPlugin.init();
                if (Platform.isAndroid) {
                  final isHelpCenterShowing =
                      await _zendeskUnifiedPlugin.showHelpCenter();
                  log(
                    'isInitialized: $isInitialized,isHelpCenterShowing: $isHelpCenterShowing',
                    name: 'Zendesk Unified Android',
                  );
                } else {
                  final isIdentitySet =
                      await _zendeskUnifiedPlugin.setIdentity(id: 'test123');
                  final isHelpCenterShowing =
                      await _zendeskUnifiedPlugin.showHelpCenter();
                  log(
                    'isInitialized: $isInitialized, isIdentitySet: $isIdentitySet, isHelpCenterShowing: $isHelpCenterShowing',
                    name: 'Zendesk Unified',
                  );
                }
              } catch (e) {
                log(
                  'Error: $e',
                  name: 'Zendesk Unified',
                  error: e,
                );
              }
            },
            child: const Text(
              'Zendesk Platform Channel',
              textScaler: TextScaler.linear(1.4),
            ),
          ),
        ],
      ),
    );
  }
}
