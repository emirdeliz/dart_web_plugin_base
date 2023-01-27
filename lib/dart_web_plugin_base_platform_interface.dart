import 'package:dart_web_plugin_base/dart_web_plugin_base_js.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class DartWebPluginBasePlatform<M, A, R> extends PlatformInterface {
  /// Constructs a DartWebPluginBasePlatform.
  DartWebPluginBasePlatform() : super(token: _token);

  static final Object _token = Object();

  static DartWebPluginBasePlatform? _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TestAaaPlatform] when
  /// they register themselves.
  static set instance(DartWebPluginBasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// The default instance of [DartWebPluginBasePlatform] to use.
  ///
  /// Defaults to [MethodChannelDartWebPluginBase].
  static DartWebPluginBasePlatform get instance {
    return _instance!;
  }

  Future<DartWebPluginBaseChannelMessageArguments<M, R>> invokeMethodJs(
    MethodCall call,
  ) async {
    return instance.invokeMethodJs(call)
        as DartWebPluginBaseChannelMessageArguments<M, R>;
  }

  Future<int> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
