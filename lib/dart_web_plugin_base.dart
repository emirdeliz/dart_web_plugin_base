import 'package:dart_web_plugin_base/dart_web_plugin_base_js.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_web.dart';
import 'package:flutter/services.dart';

import 'dart_web_plugin_base_platform_interface.dart';

class DartWebPluginBase<K, V> extends DartWebPluginBasePlatform<K, V> {
  final void Function<K, V>(DartWebPluginBaseChannelMessageArguments)
      onMessageFromJs;

  DartWebPluginBase(this.onMessageFromJs) {
    final base = DartWebPluginBaseJs();
    base.initialize(onMessageFromJs);
  }

  @override
  Future<DartWebPluginBaseChannelMessageArguments> invokeMethodJs(
    MethodCall call,
  ) async {
    final pluginBaseWeb = DartWebPluginBaseWeb<K, V>(
      onMessageFromJs,
    );
    final result = await pluginBaseWeb.invokeMethodJs(call);
    return result;
  }
}
