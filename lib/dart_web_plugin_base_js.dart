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
class DartWebPluginBaseChannelMessageArguments {
  @JS('methodTarget')
  external String methodTarget;

  @JS('arguments')
  external dynamic arguments;

  @JS('file')
  external File? file;
}

class DartWebPluginBaseJs<K, V> {
  late void Function<K, V>(DartWebPluginBaseChannelMessageArguments)
      _onMessageFromJs;

  void initialize(onMessageFromJs) {
    _onMessageFromJs = onMessageFromJs;
    _jsSendMessageToDart = allowInterop((
      DartWebPluginBaseChannelMessageArguments arguments,
    ) {
      _handleJsCall(arguments);
    });
  }

  void _handleJsCall(DartWebPluginBaseChannelMessageArguments arguments) {
    _onMessageFromJs(arguments);
  }
}
