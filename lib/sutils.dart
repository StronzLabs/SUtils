library sutils;
export 'package:sutils/utils/simple_http.dart';
export 'package:sutils/utils/resource_manager.dart';
export 'package:sutils/utils/expanded_platform.dart';
export 'package:sutils/utils/fullscreen.dart';
export 'package:sutils/utils/stream_listener.dart';

import 'package:sutils/utils/expanded_platform.dart';
import 'package:window_manager/window_manager.dart';

final class SUtils {
    static bool _initialized = false;

    static Future<void> ensureInitialized() async {
        if (SUtils._initialized)
            return;

        await EPlatform.initialize();
        if(EPlatform.isDesktop)
            await windowManager.ensureInitialized();

        SUtils._initialized = true;
    }
}
