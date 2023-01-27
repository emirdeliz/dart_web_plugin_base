// ignore: depend_on_referenced_packages
import 'package:js/js.dart';
import 'package:universal_html/html.dart';

@JS('jsSendMessageToDart')
external set _jsSendMessageToDart(
  void Function(DartWebPluginBaseChannelMessageArguments arguments)
      onMessageFromJs,
);

@JS('jsInvokeMethod')
external Future<dynamic> jsInvokeMethod(
  DartWebPluginBaseChannelMessageArguments arguments,
);

@JS('DartWebPluginBaseChannelMessageArguments')
@anonymous
class DartWebPluginBaseChannelMessageArguments<M, A> {
  @JS('methodTarget')
  external M methodTarget;

  @JS('arguments')
  external A arguments;

  @JS('file')
  external File? file;
}

class DartWebPluginBaseJs<M, R> {
  late void Function(DartWebPluginBaseChannelMessageArguments<M, R>)?
      _onMessageFromJs;

  void initialize(
    void Function(DartWebPluginBaseChannelMessageArguments<M, R>)?
        onMessageFromJs,
  ) {
    _onMessageFromJs = onMessageFromJs;
    _jsSendMessageToDart = allowInterop((
      DartWebPluginBaseChannelMessageArguments arguments,
    ) {
      final args = DartWebPluginBaseChannelMessageArguments<M, R>();
      args.methodTarget = arguments.methodTarget;
      args.arguments = arguments.arguments;
      args.file = arguments.file;

      _handleJsCall(args);
    });
  }

  void _handleJsCall(DartWebPluginBaseChannelMessageArguments<M, R> arguments) {
    if (_onMessageFromJs != null) {
      _onMessageFromJs!(arguments);
    }
  }
}
