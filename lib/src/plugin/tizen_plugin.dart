import 'package:sutils/utils.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';

Future<void> registerWith() async {
    EPlatform.isAndroidTV = false;
    EPlatform.isTizenTV = true;
    SharedPreferencesAsyncPlatform.instance ??= InMemorySharedPreferencesAsync.empty();
}
