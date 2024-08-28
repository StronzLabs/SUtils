import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

final class HTTP {
    HTTP._();
    
    static Future<Response> _get(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        assert(url is String || url is Uri);
        headers ??= {};
        if(!headers.containsKey("User-Agent"))
            headers["User-Agent"] = "StronzLabs";

        HttpClient client = HttpClient();
        client.connectionTimeout = timeout;

        for (int i = 0; i < maxRetries; i++) {
            try {
                Request req = Request("GET", url is Uri ? url : Uri.parse(url));
                req.headers.addAll(headers);
                req.followRedirects = followRedirects;

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
        assert(url is String || url is Uri);
        headers ??= {};
        if(!headers.containsKey("User-Agent"))
            headers["User-Agent"] = "StronzLabs";

        HttpClient client = HttpClient();
        client.connectionTimeout = timeout;

        for (int i = 0; i < maxRetries; i++) {
            try {
                Request req = Request("HEAD", url is Uri ? url : Uri.parse(url));
                req.headers.addAll(headers);
                req.followRedirects = followRedirects;

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

    static Future<Map<String, String>> head(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return response.headers;
    }

    static Future<String> mime(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Map<String, String> responseHeaders = await head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return responseHeaders["content-type"] ?? "*/*";
    }

    static Future<int> status(dynamic url, {Map<String, String>? headers, bool followRedirects = true, Duration? timeout, int maxRetries = 1}) async {
        Response response = await _head(url, headers: headers, followRedirects: followRedirects, timeout: timeout, maxRetries: maxRetries);
        return response.statusCode;
    }
}