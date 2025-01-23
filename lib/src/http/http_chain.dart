import 'dart:typed_data';
import 'package:sutils/src/http/http_processor.dart';

final class HTTPChain {
    final HTTPProcessor middleware;
    const HTTPChain([this.middleware = const HTTPProcessor()]);
    
    Future<Response> _request(dynamic url, String method, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        assert(url is String || url is Uri);
        assert((fieldsBody == null && stringBody == null) || (fieldsBody != null && stringBody == null) || (fieldsBody == null && stringBody != null));
        headers ??= {};

        for (int i = 0; i < maxRetries; i++) {
            try {
                Request req = Request(method, url is Uri ? url : Uri.parse(url));
                req.headers.addAll(headers);
                req.followRedirects = followRedirects;
                if (fieldsBody != null)
                    req.bodyFields = fieldsBody;
                if (stringBody != null)
                    req.body = stringBody;

                return middleware.process(req, timeout);
            } catch (e) {
                if (i == maxRetries - 1)
                    rethrow;
            }
        }

        throw Exception("Failed to fetch resource after ${maxRetries} retries");
    }

    Future<Response> _head(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return _request(url, "HEAD", headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
    }

    Future<Response> _get(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return _request(url, "GET", headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
    }

    Future<Response> _post(dynamic url, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return _request(url, "POST", headers: headers, fieldsBody: fieldsBody, stringBody: stringBody, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
    }

    Future<Uint8List> getRaw(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _get(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        if (response.statusCode != 200)
            return Uint8List(0);

        return response.bodyBytes;
    }

    Future<String> get(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return (await _get(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries)).body;
    }

    Future<Map<String, String>> head(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return response.headers;
    }

    Future<String> mime(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Map<String, String> responseHeaders = await head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return responseHeaders["content-type"] ?? "*/*";
    }

    Future<Uri> redirect(dynamic url, {Map<String, String>? headers, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _head(url, headers: headers, followRedirects: true, timeout: timeout, maxRetries: maxRetries);
        return response.request!.url;
    }

    Future<int> status(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return response.statusCode;
    }

    Future<Uint8List> postRaw(dynamic url, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _post(url, headers: headers, fieldsBody: fieldsBody, stringBody: stringBody, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        if (response.statusCode != 200)
            return Uint8List(0);

        return response.bodyBytes;
    }

    Future<String> post(dynamic url, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return (await _post(url, headers: headers, fieldsBody: fieldsBody, stringBody: stringBody, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries)).body;
    }
}
