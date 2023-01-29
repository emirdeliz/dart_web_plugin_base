import 'dart:async';

import 'package:dart_web_plugin_base/dart_web_plugin_base_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:universal_html/html.dart';
import 'package:universal_html/js.dart' as js;
import 'package:dart_web_plugin_base_example/dart_web_plugin_base_app.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base.dart';
import 'package:dart_web_plugin_base_example/dart_web_plugin_base_utils.dart';

Future<File> _readFileFromTestResourcesFolder({
  required String filePath,
  String? type,
}) async {
  final response = await window.fetch(filePath);
  final data = await response.blob();
  final metadata = {'type': type ?? 'text/plain'};
  final filename = filePath.split('/').last;
  final file = File([data], filename, metadata);
  return file;
}

Future<DartWebPluginBase<String, String, R>> _runApp<R>({
  required WidgetTester tester,
  void Function(DartWebPluginBaseChannelMessageArguments<String, R>)?
      onMessageFromJs,
}) async {
  final dartWebPluginBasePlugin = DartWebPluginBase<String, String, R>(
    onMessageFromJs,
  );
  await tester.pumpWidget(
    MaterialApp(
      home: DartWebPluginBaseAppHomePage<R>(
        title: 'Test',
        dartWebPluginBasePlugin: dartWebPluginBasePlugin,
      ),
    ),
    const Duration(seconds: 5),
  );
  return dartWebPluginBasePlugin;
}

void evalJsTestData(Map<String, Object> data) {
  final evalContent = '''
    window.jsSendMessageToDart({
      'methodTarget': '${data['methodTarget']}',
      'arguments': '${data['arguments']}',
    });
  ''';
  js.context.callMethod('eval', [evalContent]);
}

void evalJsTestFile(String filename, String fileType, String methodTarget) {
  final evalContent = '''
    (async() => {
      const response = await window.fetch('/assets/$filename');
      const data = await response.blob();
      const metadata = {'type': '$fileType'};
      const file = new File([data], '$filename', metadata);

      window.jsSendMessageToDart({
        methodTarget: '$methodTarget}',
        file: file,
      });
    })();
  ''';
  js.context.callMethod('eval', [evalContent]);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dart web plugin base test', () {
    const filename = 'campelo.pdf';
    const fileType = 'application/pdf';
    const fileSize = 1900;

    testWidgets('Have string sent from dart to js', (tester) async {
      final dartWebPluginBasePlugin = await _runApp<String>(tester: tester);
      final args = DartWebPluginBaseChannelMessageArguments<String, String>();
      args.arguments = '';
      args.methodTarget = BarcodeJsEvents.getBarcode.name;
      final result = await sentDataToJs<String>(dartWebPluginBasePlugin, args);
      expect(result.arguments, barcodeResult);
    });

    testWidgets('Have file sent from dart to js', (tester) async {
      final file = await _readFileFromTestResourcesFolder(
        filePath: '/assets/$filename',
        type: fileType,
      );

      final args = DartWebPluginBaseChannelMessageArguments<String, dynamic>();
      args.file = file;
      args.methodTarget = BarcodeJsEvents.uploadPdf.name;
      final dartWebPluginBasePlugin = await _runApp(tester: tester);
      final result = await sentDataToJs(dartWebPluginBasePlugin, args);

      expect(result.file?.name, filename);
      expect(result.file?.type, fileType);
      expect(result.file?.size, greaterThanOrEqualTo(fileSize));
    });

    testWidgets('Have string sent from js to dart', (tester) async {
      final fromJsExpected = {
        'methodTarget': BarcodeJsEvents.getDate.name,
        'arguments': 'Mon Jan 23 2023 10:31:47 GMT-0300',
      };
      await _runApp<String>(
        tester: tester,
        onMessageFromJs: (
          DartWebPluginBaseChannelMessageArguments<String, String> result,
        ) {
          expect(result.arguments, fromJsExpected['arguments']);
          expect(result.methodTarget, fromJsExpected['methodTarget']);
        },
      );
      evalJsTestData(fromJsExpected);
    });

    testWidgets('Have file sent from js to dart', (tester) async {
      final fromJsExpected = {
        'methodTarget': BarcodeJsEvents.uploadPdf.name,
      };

      final completer = Completer<File>();
      await _runApp(
        tester: tester,
        onMessageFromJs: (
          DartWebPluginBaseChannelMessageArguments<String, dynamic> result,
        ) {
          completer.complete(result.file);
        },
      );
      evalJsTestFile(
        filename,
        fileType,
        fromJsExpected['methodTarget'].toString(),
      );

      final file = await completer.future;
      expect(file.name, filename);
      expect(file.type, fileType);
      expect(file.size, greaterThanOrEqualTo(fileSize));
    });
  });
}
