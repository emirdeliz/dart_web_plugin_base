import 'package:dart_web_plugin_base/dart_web_plugin_base_web.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart_web_plugin_base_platform_interface.dart';

/// A web implementation of the DartWebPluginBasePlatform of the DartWebPluginBase plugin.
class DartWebPluginBasePlugin<M, A, R>
    extends DartWebPluginBasePlatform<M, A, R> {
  final void Function(DartWebPluginBaseChannelMessageArguments<M, R>)?
      onMessageFromJs;

  DartWebPluginBasePlugin(this.onMessageFromJs) {
    DartWebPluginBasePlatform.instance =
        DartWebPluginBaseMethodChannel<M, A, R>();
  }

  static void registerWith(Registrar registrar) {}

  @override
  Future<DartWebPluginBaseChannelMessageArguments<M, R>> invokeMethodJs(
    MethodCall call,
  ) async {
    final result = await DartWebPluginBasePlatform.instance.invokeMethodJs(
      call,
    );
    return result as DartWebPluginBaseChannelMessageArguments<M, R>;
  }
}
