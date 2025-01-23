import 'dart:typed_data';

import 'package:sutils/src/http/http_chain.dart';

final class HTTP {
    static String userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36";

    static final HTTPChain _chain = const HTTPChain();

    static Future<Uint8List> getRaw(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1})
        => _chain.getRaw(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);

    static Future<String> get(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1})
        => _chain.get(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);

    static Future<Map<String, String>> head(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1})
        => _chain.head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);

    static Future<String> mime(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1})
        => _chain.mime(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);

    static Future<Uri> redirect(dynamic url, {Map<String, String>? headers, Duration? timeout, int maxRetries = 1})
        => _chain.redirect(url, headers: headers, timeout: timeout, maxRetries: maxRetries);

    static Future<int> status(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1})
        => _chain.status(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);

    static Future<Uint8List> postRaw(dynamic url, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1})
        => _chain.postRaw(url, headers: headers, fieldsBody: fieldsBody, stringBody: stringBody, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);

    static Future<String> post(dynamic url, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1})
        => _chain.post(url, headers: headers, fieldsBody: fieldsBody, stringBody: stringBody, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
}
