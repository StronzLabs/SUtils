import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sutils/utils.dart';

import 'src/plugin/desktop_plugin.dart' as desktop;
import 'src/plugin/android_plugin.dart' as android;
import 'src/plugin/tizen_plugin.dart' as tizen;

final class SUtils {
    static late Future<void> Function() _initializer;
    static bool _initialized = false;

    static Future<void> ensureInitialized() async {
        if(SUtils._initialized)
            return;
        SUtils._initialized = true;
        await SUtils._initializer();
        
        if(EPlatform.isTV)
            FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    }
}

final class EPlatformAndroid {
    EPlatformAndroid._();
    static void registerWith() => SUtils._initializer = android.registerWith;
}

final class SUtilsDesktop {
    SUtilsDesktop._();
    static void registerWith() => SUtils._initializer = desktop.registerWith;
}

final class SUtilsTizen {
    SUtilsTizen._();
    static void register() => SUtils._initializer = tizen.registerWith;
}
