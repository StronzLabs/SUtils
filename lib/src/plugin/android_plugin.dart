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

void registerWith() {
    Future.delayed(Duration.zero, () async {
        WidgetsFlutterBinding.ensureInitialized();
        MethodChannel channel = MethodChannel('org.stronzlabs.sutils/utils');
        EPlatform.isAndroidTV = await channel.invokeMethod<bool>('isAndroidTV') ?? false;
        _setupOrientationAndOverlays();
    });
}
