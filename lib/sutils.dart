import 'src/plugin/desktop_plugin.dart' as desktop;
import 'src/plugin/android_plugin.dart' as android;

final class EPlatformAndroid {
    EPlatformAndroid._();
    static void registerWith() => android.registerWith();
}

final class SUtilsDesktop {
    SUtilsDesktop._();
    static void registerWith() => desktop.registerWith();
}
