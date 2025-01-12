import 'package:flutter/material.dart';
import 'package:sutils/utils.dart';
import 'package:window_manager/window_manager.dart';

void registerWith() {
    Future.delayed(Duration.zero, () async {
        WidgetsFlutterBinding.ensureInitialized();
        EPlatform.isAndroidTV = false;
        await windowManager.ensureInitialized();
    });
}
