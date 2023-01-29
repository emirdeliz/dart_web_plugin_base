import 'package:dart_web_plugin_base/dart_web_plugin_base_web.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_plugin.dart';
import 'package:flutter/services.dart';
import 'dart_web_plugin_base_platform_interface.dart';

class DartWebPluginBase<M, A, R> extends DartWebPluginBasePlatform<M, A, R> {
  final void Function(DartWebPluginBaseChannelMessageArguments<M, R>)?
      onMessageFromJs;

  DartWebPluginBase(this.onMessageFromJs) {
    final base = DartWebPluginBaseJs<M, R>();
    base.initialize(onMessageFromJs);
  }

  @override
  Future<DartWebPluginBaseChannelMessageArguments<M, R>> invokeMethodJs(
    MethodCall call,
  ) async {
    final pluginBaseWeb = DartWebPluginBasePlugin<M, A, R>(
      onMessageFromJs,
    );
    final result = await pluginBaseWeb.invokeMethodJs(call);
    return result;
  }
}
