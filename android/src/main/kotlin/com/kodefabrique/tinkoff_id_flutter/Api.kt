package com.kodefabrique.tinkoff_id_flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import ru.tinkoff.core.tinkoffId.TinkoffIdAuth
import ru.tinkoff.core.tinkoffId.TinkoffIdStatusCode
import ru.tinkoff.core.tinkoffId.TinkoffTokenPayload

private lateinit var tinkoffIdAuth: TinkoffIdAuth

fun init(
    clientId: String,
    redirectUri: String,
    result: MethodChannel.Result,
    activityContext: Context
) {
    tinkoffIdAuth =
        TinkoffIdAuth(
            context = activityContext,
            clientId = clientId,
            redirectUri = redirectUri
        )
    result.success(null)
}

fun isTinkoffAuthAvailable(result: MethodChannel.Result) {
    result.success(tinkoffIdAuth.isTinkoffAppAuthAvailable())
}


fun startTinkoffAuth(
    redirectUri: String,
    result: MethodChannel.Result,
    activity: Activity,
) {
    val uri = Uri.parse(redirectUri)
    activity.startActivity(tinkoffIdAuth.createTinkoffAuthIntent(uri))
    result.success(null)
}


fun getTinkoffTokenPayload(incomingUri: String, result: MethodChannel.Result) {
    try {
        val uri = Uri.parse(incomingUri)
        when (tinkoffIdAuth.getStatusCode(uri)) {
            TinkoffIdStatusCode.SUCCESS -> {}
            TinkoffIdStatusCode.CANCELLED_BY_USER -> {
                Handler(Looper.getMainLooper()).post {
                    result.error("getTinkoffTokenPayload", "Login canceled by user.", null)
                }
                return
            }
            else -> {
                Handler(Looper.getMainLooper()).post {
                    result.error(
                        "getTinkoffTokenPayload",
                        "Failed to get token from Tinkoff Bank app.",
                        null
                    )

                }
                return
            }
        }

        val payload: TinkoffTokenPayload =
            tinkoffIdAuth.getTinkoffTokenPayload(uri).getResponse()
        Handler(Looper.getMainLooper()).post {
            result.success(
                hashMapOf(
                    "accessToken" to payload.accessToken,
                    "idToken" to payload.idToken,
                    "refreshToken" to payload.refreshToken,
                    "expiresIn" to payload.expiresIn
                )
            )
        }
    } catch (e: Exception) {
        Handler(Looper.getMainLooper()).post {
            result.error("getTinkoffTokenPayload", e.message, e.stackTraceToString())
        }

    }
}

fun updateToken(refreshToken: String, result: MethodChannel.Result) {
    try {
        val payload: TinkoffTokenPayload =
            tinkoffIdAuth.obtainTokenPayload(refreshToken).getResponse()
        val map = mapOf(
            "accessToken" to payload.accessToken,
            "idToken" to payload.idToken,
            "refreshToken" to payload.refreshToken,
            "expiresIn" to payload.expiresIn
        )
        Handler(Looper.getMainLooper()).post {
            result.success(map)
        }
    } catch (e: Exception) {
        Handler(Looper.getMainLooper()).post {
            result.error("getTinkoffTokenPayload", e.message, e.stackTraceToString())
        }
    }

}

fun signOutByRefreshToken(refreshToken: String, result: MethodChannel.Result) {
    val isSuccess = try {
        tinkoffIdAuth.signOutByRefreshToken(refreshToken).getResponse()
        true
    } catch (e: Exception) {
        Log.d("tinkoff_id", e.message, e)
        false
    }

    Handler(Looper.getMainLooper()).post {
        result.success(isSuccess)
    }
}