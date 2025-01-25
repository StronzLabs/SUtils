import 'package:wakelock_plus/wakelock_plus.dart';

final class SafeWakelock {
    SafeWakelock._();

    static Future<bool> get enabled => WakelockPlus.enabled;
    static Future<void> enable() => SafeWakelock.toggle(enable: true);
    static Future<void> disable() => SafeWakelock.toggle(enable: false);

    static Future<void> toggle({required bool enable}) async {
        try {
            await WakelockPlus.toggle(enable: enable);
        } catch (_) {
        }
    }
}