import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:sutils/sutils_method_channel.dart';

abstract class SUtilsPlatform extends PlatformInterface {
    SUtilsPlatform() : super(token: SUtilsPlatform._token);

    static final Object _token = Object();
    static SUtilsPlatform _instance = MethodChannelSUtils();
    static SUtilsPlatform get instance => _instance;

    static set instance(SUtilsPlatform instance) {
        PlatformInterface.verifyToken(instance, _token);
        SUtilsPlatform._instance = instance;
    }

    Future<bool> isAndroidTV();
}
