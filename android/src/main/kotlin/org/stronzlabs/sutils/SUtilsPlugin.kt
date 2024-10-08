package org.stronzlabs.sutils

import android.content.pm.PackageManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SUtilsPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel
    private var packageManager : PackageManager? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "org.stronzlabs.sutils/utils")
        channel.setMethodCallHandler(this)

        packageManager = flutterPluginBinding.applicationContext.packageManager
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

        packageManager = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "isAndroidTV") {
            val isTV : Boolean = packageManager?.hasSystemFeature(PackageManager.FEATURE_LEANBACK) ?: false
            result.success(isTV)
        } else
            result.notImplemented()
    }
}
