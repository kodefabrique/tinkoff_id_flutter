package com.kodefabrique.tinkoff_id_flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import ru.tbank.core.tid.TidAuth
import ru.tbank.core.tid.TidStatusCode
import ru.tbank.core.tid.TidTokenPayload

private lateinit var TidAuth: TidAuth

fun init(
    clientId: String,
    redirectUri: String,
    result: MethodChannel.Result,
    activityContext: Context
) {
    TidAuth =
        TidAuth(
            context = activityContext,
            clientId = clientId,
            redirectUri = redirectUri
        )
    result.success(null)
}

fun isTinkoffAuthAvailable(result: MethodChannel.Result) {
    result.success(TidAuth.isTBankAppAuthAvailable())
}


fun startTinkoffAuth(
    redirectUri: String,
    result: MethodChannel.Result,
    activity: Activity,
) {
    val uri = Uri.parse(redirectUri)
    val intent = TidAuth.createTidAuthIntent(uri)
    activity.startActivity(intent)
    result.success(null)
}


fun getTinkoffTokenPayload(incomingUri: String, result: MethodChannel.Result) {
    try {
        val uri = Uri.parse(incomingUri)
        when (TidAuth.getStatusCode(uri)) {
            TidStatusCode.SUCCESS -> {}
            TidStatusCode.CANCELLED_BY_USER -> {
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

        val payload: TidTokenPayload =
            TidAuth.getTidTokenPayload(uri).getResponse()
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
        val payload: TidTokenPayload =
            TidAuth.obtainTokenPayload(refreshToken).getResponse()
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
        TidAuth.signOutByRefreshToken(refreshToken).getResponse()
        true
    } catch (e: Exception) {
        Log.d("tinkoff_id", e.message, e)
        false
    }

    Handler(Looper.getMainLooper()).post {
        result.success(isSuccess)
    }
}