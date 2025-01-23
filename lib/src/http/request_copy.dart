import 'package:http/http.dart';

extension RequestCopy on Request {
    Request copyWith({
        String? method,
        Uri? url,
        Map<String, String>? headers,
        Map<String, String>? fieldsBody,
        String? stringBody,
        bool? followRedirects
    }) {
        assert((fieldsBody == null && stringBody == null) || (fieldsBody != null && stringBody == null) || (fieldsBody == null && stringBody != null));
        
        Request r = Request(
            method ?? this.method,
            url ?? this.url,  
        );

        r.headers.addAll(this.headers);
        if(headers != null) r.headers.addAll(headers);
        
        if(r.headers['content-type']?.contains("application/x-www-form-urlencoded") ?? false)
            r.bodyFields = fieldsBody ?? this.bodyFields;
        else
            r.body = stringBody ?? this.body;
        r.followRedirects = followRedirects ?? this.followRedirects;

        return r;
    }
}
