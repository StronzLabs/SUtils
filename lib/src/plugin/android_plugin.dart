import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutils/utils.dart';

void registerWith() {
    Future.delayed(Duration.zero, () async {
        WidgetsFlutterBinding.ensureInitialized();
        MethodChannel channel = MethodChannel('org.stronzlabs.sutils/utils');
        EPlatform.isAndroidTV = await channel.invokeMethod<bool>('isAndroidTV') ?? false;
    });
}
