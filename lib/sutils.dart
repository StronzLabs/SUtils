library sutils;
export 'package:sutils/utils/simple_http.dart';
export 'package:sutils/utils/resource_manager.dart';
export 'package:sutils/utils/expanded_platform.dart';
export 'package:sutils/utils/fullscreen.dart';

import 'package:sutils/utils/expanded_platform.dart';

final class SUtils {
    static Future<void> initialize() async {
        await EPlatform.initialize();
    }
}
