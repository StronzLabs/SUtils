import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sutils/sutils_platform_interface.dart';

final class EPlatform {
    EPlatform._();

    static bool get isWeb => kIsWeb;
    static bool get isDesktop => !EPlatform.isWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
    static bool get isMobile => !EPlatform.isTV && !EPlatform.isWeb && (Platform.isAndroid || Platform.isIOS);

    static bool get isMobileWeb => EPlatform.isWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
    static bool get isDesktopWeb => EPlatform.isWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS);

    static bool get isAndroidTV => EPlatform._isAndroidTV;
    static bool get isTV => EPlatform.isAndroidTV;
    
    static late final bool _isAndroidTV;

    static Future<void> initialize() async {
        EPlatform._isAndroidTV = await SUtilsPlatform.instance.isAndroidTV();
    }
}