import 'package:dart_web_plugin_base/dart_web_plugin_base.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_constants.dart';
import 'package:dart_web_plugin_base/dart_web_plugin_base_js.dart';
import 'package:flutter/services.dart';

class Barcode {
  String bank;
  String address;
  String number;

  Barcode({
    this.bank = '',
    this.address = '',
    this.number = '',
  });
}

enum BarcodeJsEvents { getBarcode, getDate, uploadPdf }

const String barcodeResult = '858600000012212203852130540716213509968398132948';

Future<DartWebPluginBaseChannelMessageArguments> sentDataToJs(
  DartWebPluginBase dartWebPluginBasePlugin,
  DartWebPluginBaseChannelMessageArguments args,
) async {
  final data = await dartWebPluginBasePlugin.invokeMethodJs(
    MethodCall(
      DartWebPluginBaseChannelMessage.sendMethodMessageToClient.name,
      args,
    ),
  );
  return data;
}
