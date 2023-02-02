package com.kodefabrique.tinkoff_id_flutter

import android.app.Activity
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMethodCodec

/** TinkoffIdFlutterPlugin */
class TinkoffIdFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var backgroundChannel: MethodChannel
    var activity: Activity? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tinkoff_id_flutter")
        val taskQueue = flutterPluginBinding.binaryMessenger.makeBackgroundTaskQueue()
        backgroundChannel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "tinkoff_id_flutter_background",
            StandardMethodCodec.INSTANCE,
            taskQueue
        )
        channel.setMethodCallHandler(this)
        backgroundChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val arguments = call.arguments as Map<*, *>
        when (call.method) {
            "init" -> init(
                arguments["clientId"] as String,
                arguments["redirectUri"] as String,
                result,
                activity!!.applicationContext
            )
            "isTinkoffAuthAvailable" -> isTinkoffAuthAvailable(result)
            "startTinkoffAuth" -> startTinkoffAuth(
                arguments["redirectUri"] as String,
                result,
                activity!!
            )
            "getTinkoffTokenPayload" -> getTinkoffTokenPayload(
                arguments["incomingUri"] as String,
                result
            )
            "updateToken" -> updateToken(arguments["refreshToken"] as String, result)
            "signOutByRefreshToken" -> signOutByRefreshToken(
                arguments["refreshToken"] as String,
                result
            )
            else -> result.notImplemented()
        }


    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        backgroundChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }


}
