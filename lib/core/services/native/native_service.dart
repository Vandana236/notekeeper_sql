import 'package:flutter/services.dart';

class NativeService {

  static const MethodChannel _channel =
  MethodChannel(
    'battery_channel',
  );

  static Future<int> getBatteryLevel()
  async {

    try {

      final int batteryLevel =
      await _channel.invokeMethod(
        'getBatteryLevel',
      );

      return batteryLevel;

    } catch (e) {

      return 0;
    }
  }
}