import 'package:flutter/material.dart';
import 'package:sutils/utils.dart';
import 'package:window_manager/window_manager.dart';

Future<void> registerWith() async {
    WidgetsFlutterBinding.ensureInitialized();
    EPlatform.isAndroidTV = false;
    await windowManager.ensureInitialized();
}
