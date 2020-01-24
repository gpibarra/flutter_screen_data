import 'dart:ui';
import 'dart:math';
import 'package:flutter/services.dart';

class DeviceSize {
  //https://stackoverflow.com/questions/2193457/is-there-a-way-to-determine-android-physical-screen-height-in-cm-or-inches
  static const platformMethodChannel = const MethodChannel('com.test/test');

  static double _width;
  static double _height;
  static double _widthDpi;
  static double _heightDpi;

  DeviceSize._();

  static Size get size => Size(_width, _height);
  static double get widthDpi => _widthDpi;
  static double get heightDpi => _heightDpi;
  static double get dpi => _calcDpi(_widthDpi, _heightDpi);
  static double get screenSize =>
      _calcSizeInches(size.width, size.height, _widthDpi, _heightDpi);
  static String get dpiType {
    double _dpi = dpi;
    if (_dpi<120) {
      return "ldpi";
    }
    else if (_dpi>=120 && _dpi<160) {
      return "mdpi";
    }
    else if (_dpi>=160 && _dpi<240) {
      return "hdpi";
    }
    else if (_dpi>=240 && _dpi<320) {
      return "xhdpi";
    }
    else if (_dpi>=320 && _dpi<480) {
      return "xxhdpi";
    }
    else if (_dpi>=480 && _dpi<640) {
      return "xxxhdpi";
    }
    return "?-dpi";
  }

  static Future<void> init() async {
    _width = await platformMethodChannel.invokeMethod('getWidth');
    _height = await platformMethodChannel.invokeMethod('getHeight');
    _widthDpi = await platformMethodChannel.invokeMethod('getWidthDPI');
    _heightDpi = await platformMethodChannel.invokeMethod('getHeightDPI');
  }

  static Future<Size> getRealSizePixels({bool force: true}) async {
    try {
      double width = _width;
      double height = _height;
      if (force) {
        width = await platformMethodChannel.invokeMethod('getWidth');
        height = await platformMethodChannel.invokeMethod('getHeight');
      }
      return Size(width, height);
    } on PlatformException catch (e) {
      print("Error: ${e.message}.");
      return Size(0, 0);
    }
  }

  static Future<double> getRealDpi({bool force: true}) async {
    try {
      double widthDpi = _widthDpi;
      double heightDpi = _heightDpi;
      if (force) {
        widthDpi = await platformMethodChannel.invokeMethod('getWidthDPI');
        heightDpi = await platformMethodChannel.invokeMethod('getHeightDPI');
      }
      return _calcDpi(widthDpi, heightDpi);
    } on PlatformException catch (e) {
      print("Error: ${e.message}.");
      return 0.0;
    }
  }

  static double _calcDpi(double widthDpi, double heightDpi) {
    return (widthDpi + heightDpi) / 2.0;
//    return sqrt(pow(widthDpi, 2) + pow(heightDpi, 2));
  }

  static Future<double> getRealSizeInches({bool force: true}) async {
    try {
      double width = _width;
      double height = _height;
      double widthDpi = _widthDpi;
      double heightDpi = _heightDpi;
      if (force) {
        width = await platformMethodChannel.invokeMethod('getWidth');
        height = await platformMethodChannel.invokeMethod('getHeight');
        widthDpi = await platformMethodChannel.invokeMethod('getWidthDPI');
        heightDpi = await platformMethodChannel.invokeMethod('getHeightDPI');
      }
      return _calcSizeInches(width, height, widthDpi, heightDpi);
    } on PlatformException catch (e) {
      print("Error: ${e.message}.");
      return 0.0;
    }
  }

  static double _calcSizeInches(
      double width, double height, double widthDpi, double heightDpi) {
    double x = pow(width / widthDpi, 2);
    double y = pow(height / heightDpi, 2);
    double screenInches = sqrt(x + y);
    return screenInches;
  }
}
