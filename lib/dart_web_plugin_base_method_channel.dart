import 'package:dart_web_plugin_base/dart_web_plugin_base_constants.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_js.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/js_util.dart';
import 'dart_web_plugin_base_platform_interface.dart';

class DartWebPluginBaseMethodChannel<K, V>
    extends DartWebPluginBasePlatform<K, V> {
  final void Function<K, V>(DartWebPluginBaseChannelMessageArguments)
      onMessageFromJs;

  DartWebPluginBaseMethodChannel(this.onMessageFromJs);

  @override
  Future<DartWebPluginBaseChannelMessageArguments> invokeMethodJs(
    MethodCall call,
  ) async {
    final method = DartWebPluginBaseChannelMessage.values.firstWhere(
      (f) => f.name == call.method,
      orElse: () => DartWebPluginBaseChannelMessage.sendMethodMessageToClient,
    );

    switch (method) {
      case DartWebPluginBaseChannelMessage.sendMethodMessageToClient:
        {
          final arguments = DartWebPluginBaseChannelMessageArguments();
          arguments.methodTarget = call.arguments.methodTarget;
          arguments.arguments = call.arguments.arguments;
          arguments.file = call.arguments.file;
          return await onMessageFromDart(arguments);
        }
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'flutter_plugin for web doesn\'t implement \'${method.name}\'',
        );
    }
  }

  Future<DartWebPluginBaseChannelMessageArguments> onMessageFromDart(
    DartWebPluginBaseChannelMessageArguments arguments,
  ) async {
    final response = await promiseToFuture(
      await jsInvokeMethod(
        arguments,
      ),
    );

    final result = DartWebPluginBaseChannelMessageArguments();
    result.methodTarget = response.methodTarget;
    result.arguments = response.arguments;
    result.file = response.file;
    return result;
  }
}
