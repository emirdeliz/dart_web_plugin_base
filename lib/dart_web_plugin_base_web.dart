import 'package:dart_web_plugin_base/dart_web_plugin_base_js.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart_web_plugin_base_platform_interface.dart';

/// A web implementation of the DartWebPluginBasePlatform of the DartWebPluginBase plugin.
class DartWebPluginBaseWeb<K, V> extends DartWebPluginBasePlatform<K, V> {
  final void Function<K, V>(DartWebPluginBaseChannelMessageArguments)
      onMessageFromJs;

  DartWebPluginBaseWeb(this.onMessageFromJs) {
    DartWebPluginBasePlatform.instance = DartWebPluginBaseMethodChannel<K, V>(
      onMessageFromJs,
    );
  }

  static void registerWith(Registrar registrar) {}

  @override
  Future<DartWebPluginBaseChannelMessageArguments> invokeMethodJs(
    MethodCall call,
  ) async {
    final result = await DartWebPluginBasePlatform.instance.invokeMethodJs(
      call,
    );
    return result;
  }
}
