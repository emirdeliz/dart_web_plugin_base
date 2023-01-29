import 'package:dart_web_plugin_base/dart_web_plugin_base_constants.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_web.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/js_util.dart';
import 'dart_web_plugin_base_platform_interface.dart';

class DartWebPluginBaseMethodChannel<M, A, R>
    extends DartWebPluginBasePlatform<M, A, R> {
  @override
  Future<DartWebPluginBaseChannelMessageArguments<M, R>> invokeMethodJs(
    MethodCall call,
  ) async {
    final method = DartWebPluginBaseChannelMessage.values.firstWhere(
      (f) => f.name == call.method,
      orElse: () => DartWebPluginBaseChannelMessage.sendMethodMessageToClient,
    );

    switch (method) {
      case DartWebPluginBaseChannelMessage.sendMethodMessageToClient:
        {
          final arguments = DartWebPluginBaseChannelMessageArguments<M, A>();
          arguments.methodTarget = call.arguments.methodTarget;
          arguments.arguments = call.arguments.arguments ?? '';
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

  Future<DartWebPluginBaseChannelMessageArguments<M, R>> onMessageFromDart(
    DartWebPluginBaseChannelMessageArguments<M, A> arguments,
  ) async {
    final response =
        await promiseToFuture<DartWebPluginBaseChannelMessageArguments<M, R>>(
      jsInvokeMethod(
        arguments,
      ),
    );
    return response;
  }
}
