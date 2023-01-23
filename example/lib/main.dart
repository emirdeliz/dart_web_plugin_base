import 'package:dart_web_plugin_base_example/dart_web_plugin_base_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DartWebPluginDemoApp());
}

class DartWebPluginDemoApp extends StatelessWidget {
  const DartWebPluginDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'DartWebPluginDemo Example',
      home: Scaffold(
        backgroundColor: Color.fromRGBO(22, 27, 34, 1),
        body: Center(
          child: DartWebPluginBaseAppHomePage(
            title: 'Dart web plugin base - Make calls from flutter to js',
          ),
        ),
      ),
    );
  }
}
