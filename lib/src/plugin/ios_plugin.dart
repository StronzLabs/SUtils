import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutils/utils.dart';

void _setupOrientationAndOverlays() {
    SystemChrome.setPreferredOrientations([
        if(EPlatform.isTV || EPlatform.isTablet) ...[
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
        ] else
            DeviceOrientation.portraitUp
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
    ));
}

Future<void> registerWith() async {
    WidgetsFlutterBinding.ensureInitialized();
    EPlatform.isTizenTV = false;
    EPlatform.isAndroidTV = false;
    _setupOrientationAndOverlays();
}
