package com.example.flutter_screen_data;

import android.os.Build;
import android.util.DisplayMetrics;
import android.graphics.Point;
import android.util.Pair;
import android.view.Display;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.test/test";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
        (MethodCall methodCall, Result result) ->  {
          if (methodCall.method.equals("getWidth")) {
            Point p = getRealDeviceSizeInPixels();
            double w = p.x;
            result.success(w);
          }
          if (methodCall.method.equals("getHeight")) {
            Point p = getRealDeviceSizeInPixels();
            double h = p.y;
            result.success(h);
          }
          if (methodCall.method.equals("getWidthDPI")) {
            Pair<Float, Float> p = getReal();
            double wDpi = p.first;
            result.success(wDpi);
          }
          if (methodCall.method.equals("getHeightDPI")) {
            Pair<Float, Float> p = getReal();
            double hDpi = p.second;
            result.success(hDpi);
          }
      }
    );
  }

  private Point getRealDeviceSizeInPixels() {
    WindowManager windowManager = getWindowManager();
    Display display = windowManager.getDefaultDisplay();
    DisplayMetrics displayMetrics = new DisplayMetrics();
    display.getMetrics(displayMetrics);


    // since SDK_INT = 1;
    int mWidthPixels = displayMetrics.widthPixels;
    int mHeightPixels = displayMetrics.heightPixels;

    // includes window decorations (statusbar bar/menu bar)
    if (Build.VERSION.SDK_INT >= 14 && Build.VERSION.SDK_INT < 17) {
      try {
        mWidthPixels = (Integer) Display.class.getMethod("getRawWidth").invoke(display);
        mHeightPixels = (Integer) Display.class.getMethod("getRawHeight").invoke(display);
      } catch (Exception ignored) {
      }
    }

    // includes window decorations (statusbar bar/menu bar)
    if (Build.VERSION.SDK_INT >= 17) {
      try {
        Point realSize = new Point();
        Display.class.getMethod("getRealSize", Point.class).invoke(display, realSize);
        mWidthPixels = realSize.x;
        mHeightPixels = realSize.y;
      } catch (Exception ignored) {
      }
    }

    Point returnData = new Point(mWidthPixels, mHeightPixels);
    return returnData;
  }

  private Pair<Float, Float> getReal() {
    DisplayMetrics dm = new DisplayMetrics();
    getWindowManager().getDefaultDisplay().getMetrics(dm);
    Pair<Float, Float> returnData = new Pair(dm.xdpi, dm.ydpi);
    return returnData;
  }
}
