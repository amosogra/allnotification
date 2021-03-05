package com.floodcode.plugins.allnotification

import androidx.annotation.NonNull

import android.content.ContentResolver
import android.content.Context
import android.media.RingtoneManager
import java.util.*

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** AllnotificationPlugin */
class AllnotificationPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  //This local reference serves to store the Android application’s Context for the running app
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext()
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "allnotification")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } 
    else if ("drawableToUri" == call.method) {
      val resourceId = context.resources.getIdentifier(call.arguments as String, "drawable", context.packageName)
      result.success(resourceToUriString(context, resourceId))
    }
    else if ("getCurrentAppPackageName" == call.method) {
      result.success(context.packageName)
    } 
    else if ("getAlarmUri" == call.method) {
      result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString())
    }
    else if ("getRingToneUri" == call.method) {
      result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE).toString())
    }
    else if ("getNotificationUri" == call.method) {
      result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION).toString())
    }
    else if ("getTimeZoneName" == call.method) {
      result.success(TimeZone.getDefault().id)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun resourceToUriString(context: Context, resId: Int): String? {
        return (ContentResolver.SCHEME_ANDROID_RESOURCE + "://"
                + context.resources.getResourcePackageName(resId)
                + "/"
                + context.resources.getResourceTypeName(resId)
                + "/"
                + context.resources.getResourceEntryName(resId))
    }
}
