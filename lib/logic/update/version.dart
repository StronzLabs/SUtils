
import 'dart:async';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sutils/logic/update/updater.dart';

final class VersionChecker {
    VersionChecker._();

    static Future<String> _getLastVersion() async {
        Map<String, dynamic> release = await Updater.latestRelease;
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = release["name"].toString().split("${packageInfo.appName} ")[1];
        return version;
    }

    static Future<String> getCurrentVersion() async {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        return packageInfo.version;
    }

    static Future<bool> shouldUpdate() async {
        try {
            String currentVersion = await VersionChecker.getCurrentVersion();
            String lastVersion = await VersionChecker._getLastVersion();
            return currentVersion != lastVersion;
        } catch (_) {
            return false;
        }
    }

    static Future<Stream<double>?> update() async {
        return Updater.create().doUpdate();
    }
}
