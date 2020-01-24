import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_data/Density.dart';
import 'package:flutter_screen_data/DeviceSize.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Screen Data',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        primaryColor: Colors.lightGreen,
        primaryColorDark: Colors.lightGreen,
      ),
      home: ScreenData(),
    );
  }
}

class ScreenData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = window.physicalSize;
    final Size flutterSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: DeviceSize.init(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ScreenDataView(
              deviceRealScreenInit: true,
              deviceScreenSize: deviceSize,
              flutterScreenSize: flutterSize);
        } else {
          return ScreenDataView(
              deviceRealScreenInit: false,
              deviceScreenSize: deviceSize,
              flutterScreenSize: flutterSize);
        }
      },
    );
  }
}

class ScreenDataView extends StatelessWidget {
  final bool deviceRealScreenInit;
  final Size deviceScreenSize;
  final Size flutterScreenSize;

  ScreenDataView(
      {this.deviceRealScreenInit,
      this.deviceScreenSize,
      this.flutterScreenSize});
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    String type = "";
    String width = "";
    String height = "";
    String size = "";
    String density = "";
    String ratio = "";

    if (deviceRealScreenInit) {
      type = DeviceSize.dpiType;
      width = DeviceSize.size.width.toInt().toString();
      height = DeviceSize.size.height.toInt().toString();
      size = DeviceSize.screenSize.toStringAsFixed(2);
      density = DeviceSize.dpi.toStringAsFixed(2);
      ratio = Density(DeviceSize.size).toString();
    }

    String typeApp = "?-dpi";
    if (window.devicePixelRatio == 0.75) {
      typeApp = "ldpi";
    } else if (window.devicePixelRatio == 1.0) {
      typeApp = "mdpi";
    } else if (window.devicePixelRatio == 1.5) {
      typeApp = "hdpi";
    } else if (window.devicePixelRatio == 2.0) {
      typeApp = "xhdpi";
    } else if (window.devicePixelRatio == 3.0) {
      typeApp = "xxhdpi";
    } else if (window.devicePixelRatio == 4.0) {
      typeApp = "xxxhdpi";
    }
    String flutterAppWidth = deviceScreenSize.width.toInt().toString();
    String flutterAppHeight = deviceScreenSize.height.toInt().toString();
    String flutterAppRatio = Density(deviceScreenSize).toString();
    String flutterAppMediaType = window.devicePixelRatio.toString();
    String flutterAppMediaWidth = flutterScreenSize.width.toInt().toString();
    String flutterAppMediaHeight = flutterScreenSize.height.toInt().toString();
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("Screen Data", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 2.0,
            ),
            preferredSize: Size.fromHeight(2.0)),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("$type"),
          Text("Width: $width px"),
          Text("Height: $height px"),
          Text("Size: $size inches"),
          Text("Density: $density ppi"),
          Text("Ratio: $ratio"),
          SizedBox(
            height: 50.0,
          ),
          Text("$typeApp"),
          Text("Flutter App Width: $flutterAppWidth px"),
          Text("Flutter App Height: $flutterAppHeight px"),
          Text("Flutter App Ratio: $flutterAppRatio"),
          SizedBox(
            height: 20.0,
          ),
          Text("x$flutterAppMediaType"),
          Text("Flutter Media Width: $flutterAppMediaWidth px"),
          Text("Flutter Media Height: $flutterAppMediaHeight px"),
        ],
      )),
    );
  }
}
