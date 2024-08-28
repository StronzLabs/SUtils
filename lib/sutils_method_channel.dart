import 'dart:io';

import 'package:flutter/services.dart';

import 'package:sutils/sutils_platform_interface.dart';

class MethodChannelSUtils extends SUtilsPlatform {
    final MethodChannel _methodChannel = const MethodChannel('org.stronzlabs.sutils/utils');

    @override
    Future<bool> isAndroidTV() async {
        if(!Platform.isAndroid)
            return false;

        return await this._methodChannel.invokeMethod<bool>('isAndroidTV') ?? false;
    }
}
