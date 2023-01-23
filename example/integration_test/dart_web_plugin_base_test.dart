import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:universal_html/html.dart';
import 'package:universal_html/js.dart' as js;
import 'package:dart_web_plugin_base/dart_web_plugin_base_js.dart';
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

Future<DartWebPluginBase> _runApp({
  required WidgetTester tester,
  void Function<K, V>(DartWebPluginBaseChannelMessageArguments)?
      onMessageFromJs,
}) async {
  final dartWebPluginBasePlugin = DartWebPluginBase(
    onMessageFromJs ?? <K, V>(DartWebPluginBaseChannelMessageArguments d) {},
  );
  await tester.pumpWidget(
    MaterialApp(
      home: DartWebPluginBaseAppHomePage(
        title: 'Test',
        dartWebPluginBasePlugin: dartWebPluginBasePlugin,
      ),
    ),
    const Duration(seconds: 3),
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
    testWidgets('Have string sent from dart to js', (tester) async {
      final dartWebPluginBasePlugin = await _runApp(tester: tester);
      final args = DartWebPluginBaseChannelMessageArguments();
      args.arguments = '';
      args.methodTarget = BarcodeJsEvents.getBarcode.name;
      final result = await sentDataToJs(dartWebPluginBasePlugin, args);
      expect(result.arguments, barcodeResult);
    });

    testWidgets('Have file sent from dart to js', (tester) async {
      const filename = 'campelo.pdf';
      const fileType = 'application/pdf';
      const fileSize = 1987;
      final file = await _readFileFromTestResourcesFolder(
        filePath: '/assets/$filename',
        type: fileType,
      );

      final args = DartWebPluginBaseChannelMessageArguments();
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
      await _runApp(
        tester: tester,
        onMessageFromJs: <K, V>(
          DartWebPluginBaseChannelMessageArguments result,
        ) {
          expect(result.arguments, fromJsExpected['arguments']);
          expect(result.methodTarget, fromJsExpected['methodTarget']);
        },
      );
      evalJsTestData(fromJsExpected);
    });

    testWidgets('Have file sent from js to dart', (tester) async {
      const filename = 'campelo.pdf';
      const fileType = 'application/pdf';
      const fileSize = 1988;

      final fromJsExpected = {
        'methodTarget': BarcodeJsEvents.uploadPdf.name,
      };

      await _runApp(
        tester: tester,
        onMessageFromJs: <K, V>(
          DartWebPluginBaseChannelMessageArguments result,
        ) {
          expect(result.file?.name, filename);
          expect(result.file?.type, fileType);
          expect(result.file?.size, greaterThanOrEqualTo(fileSize));
        },
      );
      evalJsTestFile(
        filename,
        fileType,
        fromJsExpected['methodTarget'].toString(),
      );
    });
  });
}
