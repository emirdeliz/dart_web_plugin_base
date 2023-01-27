import 'package:dart_web_plugin_base/dart_web_plugin_base.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_js.dart';
import 'package:dart_web_plugin_base_example/dart_web_plugin_base_utils.dart';
import 'package:flutter/material.dart';

class DartWebPluginBaseAppHomePage<R> extends StatefulWidget {
  final DartWebPluginBase<String, String, R>? dartWebPluginBasePlugin;

  const DartWebPluginBaseAppHomePage({
    Key? key,
    required this.title,
    this.dartWebPluginBasePlugin,
  }) : super(key: key);
  final String title;

  @override
  State<DartWebPluginBaseAppHomePage<R>> createState() =>
      _DartWebPluginBaseAppHomePageState<R>();
}

class _DartWebPluginBaseAppHomePageState<R>
    extends State<DartWebPluginBaseAppHomePage<R>> {
  String dartToJsResult = '';
  late DartWebPluginBase<String, String, R> _dartWebPluginBasePlugin;

  @override
  void initState() {
    super.initState();
    _dartWebPluginBasePlugin = widget.dartWebPluginBasePlugin ??
        DartWebPluginBase<String, String, R>(null);
  }

  void _callJs() async {
    final args = DartWebPluginBaseChannelMessageArguments<String, String>();
    args.arguments = '';
    args.methodTarget = BarcodeJsEvents.getBarcode.name;

    final data = await sentDataToJs(_dartWebPluginBasePlugin, args);
    setState(() {
      dartToJsResult = data.arguments.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart web plugin base - Make calls from flutter to js - example',
      home: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              padding: MaterialStateProperty.all(
                const EdgeInsets.all(15),
              ),
            ),
            onPressed: () => _callJs(),
            child: const Text(
              "Call Js",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              dartToJsResult,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
