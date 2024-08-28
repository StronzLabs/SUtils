library sutils;
export 'package:sutils/utils/simple_http.dart';
export 'package:sutils/utils/resource_manager.dart';
export 'package:sutils/utils/expanded_platform.dart';
export 'package:sutils/utils/fullscreen.dart';

import 'package:sutils/utils/expanded_platform.dart';

final class SUtils {
    static bool _initialized = false;

    static Future<void> ensureInitialized() async {
        if (SUtils._initialized)
            return;

        await EPlatform.initialize();
    
        SUtils._initialized = true;
    }
}
