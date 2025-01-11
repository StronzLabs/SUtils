import 'dart:io';
import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:sutils/utils.dart';

final class ResourceManager {
    ResourceManager._();

    static Future<String> type(Uri uri) async {
        if (uri.scheme == "http" || uri.scheme == "https")
            return await HTTP.mime(uri);

        return lookupMimeType(uri.toString()) ?? "unknown";
    }

    static Future<String> fetch(Uri uri) async {
        if (uri.scheme == "http" || uri.scheme == "https")
            return await HTTP.get(uri);

        File file = File.fromUri(uri);
        return await file.readAsString();
    }

    static Future<Uint8List> fetchRaw(Uri uri) async {
        if (uri.scheme == "http" || uri.scheme == "https")
            return await HTTP.getRaw(uri);

        File file = File.fromUri(uri);
        return await file.readAsBytes();
    }
}
