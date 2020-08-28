export 'form/form.dart';
export 'form/form_row.dart';
export 'form/form_cell.dart';
export 'form/form_validation.dart';

import 'dart:async';

import 'package:flutter/services.dart';

class Tform {
  static const MethodChannel _channel = const MethodChannel('tform');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
