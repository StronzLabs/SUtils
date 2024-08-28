package org.stronzlabs.sutils

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SUtilsPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "org.stronzlabs.sutils/utils")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "isAndroidTV") {
            val isTV : Boolean = packageManager?.hasSystemFeature(PackageManager.FEATURE_TELEVISION) ?: false
            result.success(isTV)
        } else
            result.notImplemented()
    }
}
