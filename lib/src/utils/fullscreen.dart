import 'package:flutter/material.dart';
import 'package:sutils/utils.dart';
import 'package:window_manager/window_manager.dart';

final class FullScreen {
    FullScreen._();

    static final ValueNotifier<bool> notifier = ValueNotifier(false);

    static Future<void> set(bool fullscreen) async {
        await windowManager.setFullScreen(fullscreen);
        FullScreen.notifier.value = fullscreen;
    }

    static Future<void> toggle() async {
        await FullScreen.set(!await FullScreen.check());
    }

    static Future<bool> check() async {
        if(!EPlatform.isDesktop)
            return false;

        return FullScreen.notifier.value = await windowManager.isFullScreen();
    }

    static bool checkSync() {
        if(!EPlatform.isDesktop)
            return false;

        return FullScreen.notifier.value;
    }
}
