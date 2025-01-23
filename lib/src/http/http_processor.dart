import 'dart:io';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:sutils/src/http/simple_http.dart';

export 'package:http/http.dart' show Request, Response;

class HTTPProcessor {
    static final bool _useProxy = false;

    final HTTPProcessor? _parent;
    HTTPProcessor get parent => _parent ?? this;

    const HTTPProcessor([this._parent = const HTTPProcessor.simple()]);
    const HTTPProcessor.simple() : _parent = null;

    Future<Request> beforeRequest(Request request) async {
        return request;
    }

    Future<Response> afterRequest(Response response) async {
        return response;
    }

    Future<Response> process(Request request, Duration? timeout) async {
        request = await this.beforeRequest(request);

        HttpClient client = HttpClient();
        client.userAgent = HTTP.userAgent;
        client.connectionTimeout = timeout;

        if(HTTPProcessor._useProxy)
            client.findProxy = (_) => "PROXY 127.0.0.1:8080";

        IOClient ioClient = IOClient(client);
        StreamedResponse stream = await ioClient.send(request);
        Response resp = await Response.fromStream(stream);

        return await this.afterRequest(resp);
    }
}
