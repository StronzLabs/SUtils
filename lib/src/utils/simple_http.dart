import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

final class HTTP {

    static String userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36";
    static final bool _useProxy = false;

    HTTP._();
    
    static Future<Response> _request(dynamic url, String method, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        assert(url is String || url is Uri);
        assert((fieldsBody == null && stringBody == null) || (fieldsBody != null && stringBody == null) || (fieldsBody == null && stringBody != null));
        headers ??= {};

        HttpClient client = HttpClient();
        client.userAgent = HTTP.userAgent;
        client.connectionTimeout = timeout;

        if(HTTP._useProxy)
            client.findProxy = (_) => "PROXY 127.0.0.1:8080";

        for (int i = 0; i < maxRetries; i++) {
            try {
                Request req = Request(method, url is Uri ? url : Uri.parse(url));
                req.headers.addAll(headers);
                req.followRedirects = followRedirects;
                if (fieldsBody != null)
                    req.bodyFields = fieldsBody;
                if (stringBody != null)
                    req.body = stringBody;

                IOClient ioClient = IOClient(client);
                StreamedResponse response = await ioClient.send(req);
                return Response.fromStream(response);
            } catch (e) {
                if (i == maxRetries - 1)
                    rethrow;
            }
        }

        throw Exception("Failed to fetch resource after ${maxRetries} retries");
    }

    static Future<Response> _get(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return _request(url, "GET", headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
    }


    static Future<Uint8List> getRaw(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _get(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        if (response.statusCode != 200)
            return Uint8List(0);

        return response.bodyBytes;
    }

    static Future<String> get(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return (await _get(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries)).body;
    }

    static Future<Response> _head(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return _request(url, "HEAD", headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
    }

    static Future<Map<String, String>> head(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return response.headers;
    }

    static Future<String> mime(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Map<String, String> responseHeaders = await head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return responseHeaders["content-type"] ?? "*/*";
    }

    static Future<Uri> redirect(dynamic url, {Map<String, String>? headers, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _head(url, headers: headers, followRedirects: true, timeout: timeout, maxRetries: maxRetries);
        return response.request!.url;
    }

    static Future<int> status(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return response.statusCode;
    }

    static Future<Response> _post(dynamic url, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return _request(url, "POST", headers: headers, fieldsBody: fieldsBody, stringBody: stringBody, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
    }

    static Future<Uint8List> postRaw(dynamic url, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _post(url, headers: headers, fieldsBody: fieldsBody, stringBody: stringBody, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        if (response.statusCode != 200)
            return Uint8List(0);

        return response.bodyBytes;
    }

    static Future<String> post(dynamic url, {Map<String, String>? headers, Map<String, String>? fieldsBody, String? stringBody, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        return (await _post(url, headers: headers, fieldsBody: fieldsBody, stringBody: stringBody, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries)).body;
    }
}
